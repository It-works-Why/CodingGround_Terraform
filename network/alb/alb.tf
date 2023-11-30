resource "aws_lb" "alb" {
  name               = var.lb-name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.subnet_ids
}

output "alb_arn" {
  value = aws_lb.alb.arn
}