variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name   = string
    cidr   = string
    public = bool
    az     = string
  }))
}