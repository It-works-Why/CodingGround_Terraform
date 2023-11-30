resource "aws_instance" "ec2" {
  count = length(var.instances)
  ami = var.instances[count.index].ami_id
  instance_type = var.instances[count.index].instance_type
  subnet_id = var.instances[count.index].subnet_id
  associate_public_ip_address = var.instances[count.index].associate_public_ip_address
  key_name = var.instances[count.index].key_name
  security_groups = var.instances[count.index].security_group_id
  iam_instance_profile = length(var.instances[count.index].iam_instance_profile) > 0 ? var.instances[count.index].iam_instance_profile : null

  root_block_device {
    volume_size = var.instances[count.index].volume_size
    volume_type = "gp2"
    delete_on_termination = true
  }
  user_data = var.instances[count.index].user_data
  tags = var.instances[count.index].tags
}

output "instance_ids" {
  value = aws_instance.ec2.*.id
}