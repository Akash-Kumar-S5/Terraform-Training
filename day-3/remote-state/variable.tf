variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state storage"
  type        = string
  default     = "ak-123-tfstate"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "ak-tfapp-state"
}

variable "dynamodb_read_capacity" {
  description = "Read capacity units for the DynamoDB table"
  type        = number
  default     = 1
}

variable "dynamodb_write_capacity" {
  description = "Write capacity units for the DynamoDB table"
  type        = number
  default     = 1
}