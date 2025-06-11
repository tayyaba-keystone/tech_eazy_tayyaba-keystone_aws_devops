variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-0c2b8ca1dad447f8a" # example Ubuntu AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "bucket_name" {
  description = "Private S3 bucket name"
  type        = string
}
