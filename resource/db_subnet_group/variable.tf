variable "db_subnet_group_name" {
  type = string
}

variable "db_subnet_id" {
  type = list(string)
}

variable "db_subnet_group_tags" {
  type = map(string)
}