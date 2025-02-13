# vpc
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
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