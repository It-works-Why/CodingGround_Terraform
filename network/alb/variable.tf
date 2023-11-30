variable "lb-name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "security_group" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}