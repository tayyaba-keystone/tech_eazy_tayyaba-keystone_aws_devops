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

# IAM Role to allow EC2 to upload logs to S3 and push logs to CloudWatch
resource "aws_iam_role" "log_writer" {
  name = "log-writer-role-${var.stage}"
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
        Action = [
          "s3:PutObject",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "sns:Publish"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_log_policy" {
  name       = "attach-log-policy-${var.stage}"
  roles      = [aws_iam_role.log_writer.name]
  policy_arn = aws_iam_policy.log_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2-instance-profile-${var.stage}"
  role = aws_iam_role.log_writer.name
}

# add a specific policy for s3 dev and s3 prod

# Create stage-specific S3 bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "${var.bucket_name}-${var.stage}"
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

# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group (ports 22, 80, 8080)
resource "aws_security_group" "app_sg" {
  name        = "default-app-sg-${var.stage}"
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

# EC2 Instance
resource "aws_instance" "app_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = templatefile("${var.stage}_setup.sh", {
    bucket        = var.bucket_name,
    stage         = var.stage,
    github_token  = var.github_token
  })

  user_data_replace_on_change = true

  tags = {
    Name = "app-${var.stage}"
  }
}

# CloudWatch Log Group - Explicitly create this
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ec2/app-logs-${var.stage}"
  retention_in_days = 7
}

# SNS for log alert
resource "aws_sns_topic" "alert_topic" {
  name = "app-alerts-topic-${var.stage}"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Log Metric Filter
resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-filter-${var.stage}"
  log_group_name = "/ec2/app-logs-${var.stage}"
  pattern        = "\"ERROR\" \"Exception\""

  metric_transformation {
    name      = "ErrorCount-${var.stage}"
    namespace = "AppLogs"
    value     = "1"
  }
  depends_on = [aws_cloudwatch_log_group.app_logs]
}

# CloudWatch Alarm.
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "app-error-alarm-${var.stage}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = "AppLogs"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  alarm_description   = "Alarm when error is found in app logs"
  alarm_actions       = [aws_sns_topic.alert_topic.arn]
}
