terraform {
  backend "s3" {
    bucket = "tayyaba-devops-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
