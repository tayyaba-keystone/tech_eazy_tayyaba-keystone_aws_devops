# declare all the variables

variable "stage" {}
variable "ami" {
  default = "ami-020cba7c55df1f615"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "bucket_name" {}
variable "region" {
  default = "us-east-1"
}

variable "github_token" {
  description = "GitHub token for private repo access"
  type        = string
  sensitive   = true
}