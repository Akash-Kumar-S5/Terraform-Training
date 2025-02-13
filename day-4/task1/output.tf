output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of Public Subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  description = "List of Private Subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "asg_security_group_id" {
  description = "Security Group ID for ASG instances"
  value       = aws_security_group.asg_sg.id
}

output "alb_dns_name" {
  description = "DNS Name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
}