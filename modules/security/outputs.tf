output "instance_security_group_id" {
  value = aws_security_group.instance.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.instance.name
}