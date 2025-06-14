data "template_file" "user_data" {
  template = file("${path.module}/setup.sh")

  vars = {
    bucket_name = var.bucket_name
  }
}


resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = data.template_file.user_data.rendered
  key_name = "iac"
   tags = {
    Name = "AppServer"  # ✅ This is correct
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow web and SSH traffic"
  vpc_id = data.aws_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 👈 For testing only. Replace with your IP later.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppServer"
  }
}
