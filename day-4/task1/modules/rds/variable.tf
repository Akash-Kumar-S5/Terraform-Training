# vpc
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "ak-vpc"
}

# RDS Configuration
variable "rds_instance_type" {
  description = "Instance type for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Username for RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for RDS (use secrets manager for production!)"
  type        = string
  sensitive   = true
  default = "Password123"
}

variable "ec2_sg_id" {
  
}

variable "vpc_id" {
  description = "VPC ID of the existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the instance(s) will be launched"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0abcdef1234567890"]
}

variable "db_name" {
  description = "The name of the initial database"
  type        = string
  default     = "akdatabase"
}