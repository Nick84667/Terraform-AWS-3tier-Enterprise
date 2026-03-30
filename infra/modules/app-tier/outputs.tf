output "asg_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.app_instance.name
}

output "instance_role_name" {
  value = aws_iam_role.app_instance.name
}
