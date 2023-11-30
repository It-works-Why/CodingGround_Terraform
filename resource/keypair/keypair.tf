locals {
  key_exists = fileexists("${path.module}/${var.key_name}.pem")
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_sensitive_file" "private_key_pem" {
  content = tls_private_key.pk.private_key_pem
  filename          = "${path.module}/${var.key_name}.pem"
}

output "key_name" {
  value = aws_key_pair.keypair.key_name
}