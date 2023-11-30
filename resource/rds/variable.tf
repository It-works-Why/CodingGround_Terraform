variable "allocated_storage" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "skip_final_snapshot" {
  type = string
}