variable "s3bucket" {
  type = list(object({
    bucket = string
  }))
}