resource "aws_lb_target_group" "lb_target" {
  name = var.target_group_name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.lb_target.arn
}