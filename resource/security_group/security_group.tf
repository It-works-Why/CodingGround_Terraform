resource "aws_security_group" "sg" {
  count = length(var.security_groups)
  vpc_id = var.vpc_id
  name = var.security_groups[count.index].name
  description = var.security_groups[count.index].description

  lifecycle { create_before_destroy = true }
}

output "sg_ids" {
  value = { for s in aws_security_group.sg : s.name => s.id }
}