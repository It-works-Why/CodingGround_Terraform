resource "aws_s3_bucket" "s3" {
  count = length(var.s3bucket)
  bucket = var.s3bucket[count.index].bucket

  lifecycle { create_before_destroy = true }
}

output "bucket_arns" {
  value = {for b in aws_s3_bucket.s3 : b.bucket => b.arn}
}