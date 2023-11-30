resource "aws_lb_listener" "listener" {
  count             = length(var.listeners)
  load_balancer_arn = var.load_balancer_arn
  port              = var.listeners[count.index].port
  protocol          = var.listeners[count.index].protocol
  ssl_policy        = var.listeners[count.index].ssl_policy
  certificate_arn   = var.listeners[count.index].certificate_arn

  default_action {
    type = var.listeners[count.index].action_type

    dynamic "redirect" {
      for_each = var.listeners[count.index].action_type == "rediect" ? [1] : []
      content {
        protocol    = var.listeners[count.index].redirect_protocol
        port        = var.listeners[count.index].redirect_port
        status_code = var.listeners[count.index].redirect_status
      }
    }

    dynamic "forward" {
      for_each = var.listeners[count.index].action_type == "forward" ? [1] : []
      content {
        target_group {
          arn = var.listeners[count.index].target_group_arn
        }
      }
    }
  }
}