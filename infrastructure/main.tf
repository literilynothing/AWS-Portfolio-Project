terraform {
  required_version = ">= 1.5.0"

# Configure AWS provider-------------------------------------------------------
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Fetch the latest Ubuntu AMI--------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#Create a security group for the application server---------------------------
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow SSH and HTTP traffic"


#Set up ingress rules to allow SSH and HTTP traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["135.237.130.235/32"]

  }

#Set up egress rules to allow outbound traffic
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

#Set up an EC2 instance for the application server--------------------------
resource "aws_instance" "app_server_1" {
  ami           = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  instance_type = "t2.micro"

  tags = {
    Name = "App-Server-1"
  }
}