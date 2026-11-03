terraform {
  required_version = ">= 1.5.0"
}
#Set up an EC2 instance for the application server----------------------------
resource "aws_instance" "app_server_1" {
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "App-Server-1"
  }
}