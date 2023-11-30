resource "aws_ecr_repository" "repositories" {
  count                = length(var.repositories)
  name                 = var.repositories[count.index].name
  image_tag_mutability = var.repositories[count.index].mutability

  image_scanning_configuration {
    scan_on_push = var.repositories[count.index].scan_on_push
  }
}

output "repository_arns" {
  value = {for r in aws_ecr_repository.repositories : r.name => r.arn}
}