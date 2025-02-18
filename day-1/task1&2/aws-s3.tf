terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" 
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "ak-cicd-bucket" 
}

output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

