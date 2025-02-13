output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "asg_security_group_id" {
  description = "Security Group ID for ASG instances"
  value       = aws_security_group.asg_sg.id
}
