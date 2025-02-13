output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = { for k, v in aws_instance.web : k => v.public_ip }
}