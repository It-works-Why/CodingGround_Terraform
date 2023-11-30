resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = var.vpc_tags
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
