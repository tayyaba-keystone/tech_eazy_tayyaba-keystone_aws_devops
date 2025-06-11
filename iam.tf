data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "s3_readonly_role" {
  name               = "S3ReadOnlyRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "readonly_s3_attach" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "s3_writeonly_role" {
  name               = "S3WriteOnlyRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_policy" "writeonly_policy" {
  name   = "S3WriteOnlyPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:CreateBucket"],
        Resource = "*"
      },
      {
        Effect   = "Deny",
        Action   = ["s3:GetObject", "s3:ListBucket"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "writeonly_attach" {
  role       = aws_iam_role.s3_writeonly_role.name
  policy_arn = aws_iam_policy.writeonly_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-writeonly-profile"
  role = aws_iam_role.s3_writeonly_role.name
}
