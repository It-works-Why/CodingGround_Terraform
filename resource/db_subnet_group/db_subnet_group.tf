resource "aws_db_subnet_group" "db_subnet_group" {
  name = var.db_subnet_group_name
  subnet_ids = var.db_subnet_id
  tags = var.db_subnet_group_tags
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

