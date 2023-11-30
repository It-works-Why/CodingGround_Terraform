resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  identifier = var.db_name
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az = var.multi_az
  username = var.username
  password = var.password
  skip_final_snapshot = var.skip_final_snapshot
}