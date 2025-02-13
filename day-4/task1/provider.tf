terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
    CreatedBy = "akashkumars@presidio.com"
    day = "4"
    task = "1"
    environment = "training"
    }
  }
}