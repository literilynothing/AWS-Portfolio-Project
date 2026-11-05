terraform {
  required_version = ">= 1.5.0"
}

#Fetch the latest Ubuntu AMI--------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Fetch the current AWS account ID------------------------------------------------
data "aws_caller_identity" "current" {}