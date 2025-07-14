terraform {
  backend "s3" {
    bucket = "tayyaba-devops-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
