variable "security_groups" {
  type = list(object({
    name = string
    description =string
  }))
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}