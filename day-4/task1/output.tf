output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of Public Subnets"
  value       =  module.vpc.public_subnets 
}

output "private_subnets" {
  description = "List of Private Subnets"
  value       = module.vpc.private_subnets 
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = module.ec2.public_ips
}