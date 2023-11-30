resource "aws_lb_target_group_attachment" "attach_ec2" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.instance_id
  port             = var.port
}