variable "listeners" {
  type = list(object({
    port              = number
    protocol          = string
    ssl_policy        = string
    certificate_arn   = string
    target_group_arn  = string
    action_type       = string
    redirect_protocol = string
    redirect_port     = string
    redirect_status   = string
  }))
}

variable "load_balancer_arn" {
  type = string
}