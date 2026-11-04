terraform {
  required_version = ">= 1.5.0"
}

#Create a security group for the application server
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow SSH and HTTP traffic"


  #Set up ingress rules to allow SSH and HTTP traffic
  ingress {
    description = "Allow certain SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32"]

  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  #Set up egress rules to allow outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}