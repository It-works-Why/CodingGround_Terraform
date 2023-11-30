resource "aws_iam_role" "iam_role" {
  count = length(var.role_names)
  name = var.role_names[count.index]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  lifecycle { create_before_destroy = true }

}

resource "aws_iam_role_policy" "role_policy" {
  count = length(var.role_names)
  name = "${var.role_names[count.index]}_policy"
  role = aws_iam_role.iam_role[count.index].id
  policy = jsonencode(var.policy_documents[count.index])

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  count = length(var.role_names)
  name = "${var.role_names[count.index]}_profile"
  role = aws_iam_role.iam_role[count.index].name

  lifecycle { create_before_destroy = true }
}

output "iam_instance_profile_names" {
  value = aws_iam_instance_profile.iam_instance_profile[*].name
}