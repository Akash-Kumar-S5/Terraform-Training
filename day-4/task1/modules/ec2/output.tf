output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = { for k, v in aws_instance.web : k => v.public_ip }
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.web_sg.id
}