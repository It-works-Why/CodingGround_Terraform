variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  description = "Map of public subnet ids"
  type        = map(string)
}