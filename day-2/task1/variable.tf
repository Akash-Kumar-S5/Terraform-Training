# provider
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# vpc
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list(object({
    cidr = string
    az   = string
  }))
}

# asg
# AMI for EC2 instances (amazon-linux)
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0005ee01bca55ab66"
}

variable "key_name" {
  description = "EC2 Key Pair for SSH access"
  default     = "ak-pair" 
}

# EC2 instance type
variable "instance_type" {
  description = "Instance type for ASG"
  type        = string
  default     = "t2.micro"
}

# ASG Configuration
variable "asg_desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 2
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