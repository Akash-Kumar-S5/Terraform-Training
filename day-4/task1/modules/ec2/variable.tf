variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "ak-ec2-instance"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs where the instance(s) will be launched"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0abcdef1234567890"]
}

variable "key_name" {
  description = "Name of the SSH key pair for EC2 access"
  type        = string
  default     = "ak-pair"
}

variable "ssh_allowed_ip" {
  description = "allowed ip value"
  type = string
  default = "106.219.178.212/32"
}

variable "vpc_id" {
  description = "VPC ID of the existing VPC"
  type        = string
}