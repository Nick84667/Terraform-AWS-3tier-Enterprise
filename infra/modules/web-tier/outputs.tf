output "asg_name" {
  value = aws_autoscaling_group.web.name
}

output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.web_instance.name
}

output "instance_role_name" {
  value = aws_iam_role.web_instance.name
}
