# vpc
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

# asg
# AMI for EC2 instances (amazon-linux)
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0005ee01bca55ab66"
}

variable "ssh_allowed_ip" {
  description = "allowed ip value"
  type = string
  default = "14.194.142.66/32"
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