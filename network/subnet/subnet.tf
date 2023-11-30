resource "aws_subnet" "subnet" {
  count = length(var.subnets)
  vpc_id = var.vpc_id
  cidr_block = var.subnets[count.index].cidr
  availability_zone = var.subnets[count.index].az
  map_public_ip_on_launch = var.subnets[count.index].public

  tags = {
    Name = var.subnets[count.index].name
  }
}

output "subnet_ids" {
  value = { for s in aws_subnet.subnet : s.tags["Name"] => s.id }
}