# provider
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
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

