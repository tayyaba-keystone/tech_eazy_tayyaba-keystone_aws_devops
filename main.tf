terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# IAM Role to allow EC2 to upload logs to S3
resource "aws_iam_role" "log_writer" {
  name = "log-writer-role-${var.stage}"  # 🧠 Add stage
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "log_policy" {
  name = "log-policy-${var.stage}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject"],
        Resource = "arn:aws:s3:::${var.bucket_name}-${var.stage}/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_log_policy" {
  name       = "attach-log-policy-${var.stage}"
  roles      = [aws_iam_role.log_writer.name]
  policy_arn = aws_iam_policy.log_policy.arn
}
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "${var.bucket_name}-${var.stage}"  # <--- stage-specific
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "delete-logs-after7day"
    status = "Enabled"

    filter {}

    expiration {
      days = 7
    }
  }
}

# 🔸 Get Default VPC ID
data "aws_vpc" "default" {
  default = true
}

# 🔸 Security Group for port 22, 80, 8080
resource "aws_security_group" "app_sg" {
  name        = "default-app-sg-${var.stage}"  # <--- make it unique per stage
  description = "Allow SSH, HTTP, and App port"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sg-ssh-http"
  }
}
resource "aws_instance" "app_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]   # ✅ THIS IS IMPORTANT

  user_data = templatefile("${var.stage}_setup.sh", {
    bucket = var.bucket_name,
    stage  = var.stage
    github_token  = var.github_token
  })

   # ✅ Add this line below user_data
  user_data_replace_on_change = true

  tags = {
    Name = "app-${var.stage}"
  }
}