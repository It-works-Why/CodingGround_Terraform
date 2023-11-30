variable "repositories" {
  type        = list(object({
    name = string
    mutability = string
    scan_on_push = bool
  }))
}