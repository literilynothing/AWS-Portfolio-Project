terraform {
  required_version = ">= 1.5.0"
}

#Set up an EC2 instance for the application server----------------------------
resource "aws_instance" "app_server_1" {
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = var.ec2_key_pair

  tags = {
    Name = "App-Server-1"
  }
}

resource "aws_eip" "app_server_1_eip" {
  instance = aws_instance.app_server_1.id
  domain   = "vpc"
}