# Assignment 2 – Upload EC2 Logs to S3 using Terraform

This project automatically creates an EC2 instance and an S3 bucket using Terraform. When the EC2 instance is stopped or shut down, it uploads log files to the S3 bucket.

##  Tools Used

- Terraform
- AWS EC2
- AWS S3
- IAM (for roles and permissions)
- Bash script (user_data)

##  Files Included

- `main.tf` – AWS provider
- `variables.tf` – Variables like region, AMI, bucket name
- `iam.tf` – IAM roles and policies
- `s3.tf` – S3 bucket and lifecycle rule
- `ec2.tf` – EC2 instance setup and security group
- `setup.sh` – Script to upload logs on shutdown

##  Screenshots

1a. Role with S3 read-only access 
1b. Role to create/upload to S3, but no read/download 

![Image](https://github.com/user-attachments/assets/28642c82-bd8e-49ff-a09d-17a3b423e1da)

Attach Role 1b to EC2

![Image](https://github.com/user-attachments/assets/bdaf2fbe-17d3-4744-b7cb-b0292d990125)

Private S3 bucket

![Image](https://github.com/user-attachments/assets/1c02d002-99ba-4f6c-a63e-566e5305e71e)

![Image](https://github.com/user-attachments/assets/b5f0a345-058f-422e-a6f0-a925b9fa67be)

S3 lifecycle rule to delete logs after 7 days

![Image](https://github.com/user-attachments/assets/f5fbfe4e-f62f-479d-b07d-4957f1623f31)
