terraform {
  required_version = ">= 1.5.0"


  # Configure AWS provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.71.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}