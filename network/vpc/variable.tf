variable "vpc_cidr_block" {
  type = string
}

variable "vpc_tags" {
  description = "vpc name"
  type = map(string)
}