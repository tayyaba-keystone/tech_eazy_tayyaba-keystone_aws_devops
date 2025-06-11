resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "LogsBucket"
  }
}



resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "delete-logs-after-7-days"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 7
    }
  }
}
