provider "aws" {
  region = "ca-central-1"
}

module "s3" {
  source = "./resource/s3"
  s3bucket = [ 
    {
      bucket = "bsdev16-codingground"
    }
  ]
}

module "iam" {
  source = "./iam/iam_role"
  role_names = ["BSDEV16-ec2-S3-ECRaccess"]
  policy_documents = [
    {
      "Version": "2012-10-17",
      "Statement" : [
        {
          "Effect": "Allow",
          "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "ecr:GetAuthorizationToken", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"],
          "Resource": [module.s3.bucket_arns["bsdev16-codingground"], module.ecr.repository_arns["codingground-frontend"], module.ecr.repository_arns["codingground-backend"]]
        }
      ]
    }
  ]
  depends_on = [ module.s3, module.ecr ]
}

module "vpc" {
  source = "./network/vpc"
  vpc_cidr_block = "172.16.0.0/20"
  vpc_tags = {
    Name = "BSDEV16-Project-VPC"
    owner = "BSDEV16"
  }
}

locals {
  subnets = jsondecode(file("./Data/subnets.json"))
}

module "subnet" {
  source  = "./network/subnet"
  vpc_id  = module.vpc.vpc_id
  subnets = local.subnets
}

module "routetable" {
  source = "./network/routetable_igw"
  vpc_id = module.vpc.vpc_id
  # 처음 앞에서부터 6글자가 public인 서브넷을 라우팅 테이블에 등록한다는 의미
  public_subnet_ids = { for name, id in module.subnet.subnet_ids : name => id if substr(name, 0, 6) == "public" }
}

locals {
  security_groups = jsondecode(file("./Data/security_groups.json"))
}

module "security_group" {
  source = "./resource/security_group"
  vpc_id = module.vpc.vpc_id
  security_groups = local.security_groups
}

locals {
  rules = jsondecode(file("./Data/security_group_rules.json"))
}

module "aws_security_group_rule" {
  source = "./resource/security_group_rule"
  security_group_id = module.security_group
  rules = local.rules
}

# module "alb" {
#   source = "./network/alb"
#   # 로드밸런서 이름
#   lb-name = "projectalb"
#   # 형식. false면 ALB임
#   internal = false
#   # 사용하는 보안그룹, 보안그룹 모듈에서 정의한 보안그룹 입력
#   security_group = [module.security_group.sg_ids["alb_sg"]]
#   # 어떤 서브넷을 대상으로 로드밸런싱 할것인지 선택
#   subnet_ids = [ module.subnet.subnet_ids["public_subnet_a"],module.subnet.subnet_ids["public_subnet_b"]]
# }

# module "lb_listener" {
#   source = "./network/alb/lb/listener"
#   load_balancer_arn = module.alb.alb_arn
#   listeners = [
#     {
#       port = 80
#       protocol = "HTTP"
#       action_type = "redirect"
#       redirect_protocol = "HTTPS"
#       redirect_status = "HTTP_301"
#     }
#   ]
# }

# module "lb_target_group" {
#   source = "./network/alb/lb/target_group"
#   target_group_name = "lb_target"
#   vpc_id = module.vpc.vpc_id
#   port = 80
#   protocol = "HTTP"
# }

# module "lb_target_group_attach" {
#   source = "./network/alb/lb/target_group_attach"
#   lb_target_group_arn = module.lb_target_group.lb_target_group_arn
#   instance_id = module.ec2.instance_id
#   port = 80
# }

module "keypair" {
  # 키페어는 /resource/keypair에 저장됨
  source = "./resource/keypair"
  key_name = "coding-ground_server-key"
}

module "ec2" {
  source = "./resource/ec2"
  instances = [
    # 반복문이므로 필요한 만큼 복사해서 만들면 됨.
    {
      # ami_id 입력, 리전에 따라서 ami id가 달라지니 잘 확인하고 입력
      ami_id = "ami-06873c81b882339ac" #Ubuntu Server 22.04 LTS (HVM), SSD Volume Type in Canada
      # 인스턴스 크기
      instance_type = "t3.small"
      # 어느 서브넷에 배포할건지 정의. [] 안에 서브넷 이름 적어주면 됨.
      subnet_id = module.subnet.subnet_ids["public_subnet_a"]
      key_name = module.keypair.key_name
      # 보안 그룹 선택. 위에서 생성한 보안그룹 입력
      security_group_id = [module.security_group.sg_ids["ec2_sg"]]
      iam_instance_profile = module.iam.iam_instance_profile_names[0]
      # 공인 IP 할당 유무. Elastic IP 아님.
      associate_public_ip_address = "true"
      user_data = file("./ec2.sh")
      tags = {
        # ec2 이름
        Name = "BSDEV16-bastion"
        # 소유자
        owner = "BSDEV16"
      }
    },
    {
      # ami_id 입력, 리전에 따라서 ami id가 달라지니 잘 확인하고 입력
      ami_id = "ami-06873c81b882339ac" #Ubuntu Server 22.04 LTS (HVM), SSD Volume Type in Canada
      # 인스턴스 크기
      instance_type = "t3.large"
      # 어느 서브넷에 배포할건지 정의. [] 안에 서브넷 이름 적어주면 됨.
      subnet_id = module.subnet.subnet_ids["public_subnet_a"]
      key_name = module.keypair.key_name
      # 보안 그룹 선택. 위에서 생성한 보안그룹 입력
      security_group_id = [module.security_group.sg_ids["jugde0_sg"]]
      iam_instance_profile = module.iam.iam_instance_profile_names[0]
      # 공인 IP 할당 유무. Elastic IP 아님.
      associate_public_ip_address = "true"
      volume_size = 50
      user_data = file("./ec2.sh")
      tags = {
        # ec2 이름
        Name = "BSDEV16-Jugde0-ec2"
        # 소유자
        owner = "BSDEV16"
      }
    },
  ]

  depends_on = [ module.keypair, module.security_group, module.iam ]
}

module "db_subnet_group" {
  source = "./resource/db_subnet_group"
  # db 서브넷 그룹 이름 지정. 소문자만 가능.
  db_subnet_group_name = "coding-ground-db-subnet-group"
  # db 서브넷 지정
  db_subnet_id = [ module.subnet.subnet_ids["private_subnet_a"], module.subnet.subnet_ids["private_subnet_b"]]
  db_subnet_group_tags = {
    # 소유자
    owner = "BSDEV16"
  }
}

module "rds" {
  source = "./resource/rds"
  # DB 인스턴스 저장공간. GiB 단위. 최소 20GiB
  allocated_storage = 20
  # DB 이름 정의
  db_name = "bsdev16-coding-ground-db"
  # 엔진 정의
  db_engine = "mysql"
  db_engine_version = "8.0.33"
  # RDS 인스턴스 크기 정의
  db_instance_class = "db.t3.large"
  # 보안 그룹 선택. 위에서 생성한 보안그룹 입력
  db_subnet_group_name = module.db_subnet_group.db_subnet_group_name
  vpc_security_group_ids = [ module.security_group.sg_ids["rds_sg"]]
  # 다중 az 여부
  multi_az = "false"
  # MySQL 사용자 이름
  username = "admin"
  # 사용자 비밀번호
  password = "adminpassword"
  skip_final_snapshot = "true"

  depends_on = [ module.security_group, module.db_subnet_group ]
}

module "ecr" {
  source = "./resource/ecr"
  repositories = [
#    {
#      name = "codingground-frontend"
#      mutability = "MUTABLE"
#      scan_on_push = true
#    },
    {
      name = "codingground-backend"
      mutability = "MUTABLE"
      scan_on_push = true
    }
  ]
}