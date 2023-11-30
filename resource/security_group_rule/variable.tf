variable "rules" {
  type = list(object({
    type = string
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = optional(list(string))
    source_security_group_id = optional(list(string))
    security_group_id = list(string)
  }))
}