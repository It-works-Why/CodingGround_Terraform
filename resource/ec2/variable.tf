variable "instances" {
  description = "List of instances"
  type = list(object({
    ami_id = string
    instance_type = string
    subnet_id = string
    associate_public_ip_address = bool
    key_name = string
    security_group_id = list(string)
    iam_instance_profile = optional(string)
    volume_size = optional(number)
    user_data = optional(string)
    tags = map(string)
  }))
}