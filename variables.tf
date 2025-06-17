variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-0e86e20dae9224db8" # example Ubuntu AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "bucket_name" {
  description = "Private S3 bucket name"
  type        = string
}

variable "repo_url" {
  default = "https://github.com/techeazy-consulting/techeazy-devops.git"
}
