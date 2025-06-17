# Assignment 2 & Assignment3

This project automatically creates an EC2 instance and an S3 bucket using Terraform. When the EC2 instance is stopped or shut down, it uploads log files to the S3 bucket This perform using terraform CLI as well as GitHub Action.

##  Tools Used

- Terraform
- AWS EC2
- AWS S3
- IAM (for roles and permissions)
- Bash script (user_data)

## 🚀 execution steps for both Terraform CLI and GitHub Actions
This project automatically provisions an EC2 instance and an S3 bucket using Terraform. When the EC2 instance is stopped or shut down, it uploads its application log file (app.log) to the S3 bucket.

The infrastructure setup and deployment is performed using:

✅ Terraform CLI

✅ GitHub Actions (CI/CD)

ℹ️ Note: During Terraform execution, the S3 bucket name is provided dynamically via -var="bucket_name=your-bucket-name".(I have passed devops-techeazy)

# ⚙️ Execution via Terraform CLI
- Initialize Terraform
  terraform init

- Plan Infrastructure
  terraform plan -var="bucket_name=your-bucket-name"

- Apply Infrastructure
  terraform apply -auto-approve -var="bucket_name=your-bucket-name"

- Destroy Infrastructure
  terraform destroy -auto-approve -var="bucket_name=your-bucket-name"

# 🤖 Execution via GitHub Actions
  Set the following GitHub Secrets in your repository:
  
  AWS_ACCESS_KEY_ID (AWS IAM user credentials)
  AWS_SECRET_ACCESS_KEY (AWS IAM secret key)
  EC2_PRIVATE_KEY  (use own Private key contents (my private key name devops-key.pem)
  TF_VAR_BUCKET_NAME (provide S3 buket name dynamically)

  Sample Workflow File: .github/workflows/deploy.yml

  Workflow Trigger:
  On push to main branch
  Includes steps to initialize, plan, apply Terraform, Get EC2 public Ip, save EC2 private key
  After triggerd EC2, S3, Roles, S3WriteOnlyPolicy are creadted 

##  Screenshots

1a. Role with S3 read-only access 
1b. Role to create/upload to S3, but no read/download 

![Image](https://github.com/user-attachments/assets/28642c82-bd8e-49ff-a09d-17a3b423e1da)

Attach Role 1b to EC2

![Image](https://github.com/user-attachments/assets/bdaf2fbe-17d3-4744-b7cb-b0292d990125)

Private S3 bucket

![Image](https://github.com/user-attachments/assets/158b914d-32cc-4c72-ab50-f1155371ba3f)

![Image](https://github.com/user-attachments/assets/4f87a23d-cfca-4c5d-b69b-dede6354a0c6)

Upload EC2 logs after shutdown
![Image](https://github.com/user-attachments/assets/4f3119a9-45dd-4259-bb4b-300e6fd8ecf5)

Upload app logs
![Image](https://github.com/user-attachments/assets/0e9230ae-cdc3-4451-b13a-c112c3e27ea2)

S3 lifecycle rule to delete logs after 7 days

![Image](https://github.com/user-attachments/assets/f5fbfe4e-f62f-479d-b07d-4957f1623f31)

Use Role 1a to list files:Verified via AWS CLI with read-only role instance
![Image](https://github.com/user-attachments/assets/d9792abd-af32-4002-beb3-d4e700197c52)

GitHub Action Triggerd output 
![Image](https://github.com/user-attachments/assets/1323da8a-bf27-4020-bcef-4125880bd2c8)


