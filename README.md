# 🚀 DevOps Assignment 5 – Log Streaming, CloudWatch Alarm & SNS Email Alert

This project automates the provisioning of an AWS EC2 instance using Terraform and deploys a Spring Boot application. It then streams logs to CloudWatch, sets up metric filters and alarms on error patterns, and sends alerts to email via SNS.

---


## 📸 Screenshots
### 1️⃣ EC2 Instance Running
![Image](https://github.com/user-attachments/assets/40957c88-96df-4930-9105-a49bfffbd3c6)
 
### 2️⃣ Application Up Check (Port 80)
![Image](https://github.com/user-attachments/assets/f15882b8-57dd-4418-968d-5b291d52c2b0)

 ### 3️⃣ CloudWatch Log Group Visible
![Image](https://github.com/user-attachments/assets/6384a8f4-af82-4ab2-8ebe-8352a4eba81b)
 
### 4️⃣ Log Stream Entries in CloudWatch
![Image](https://github.com/user-attachments/assets/38323113-43d1-4698-885b-fb89d71e1a0f)
 
### 5️⃣ CloudWatch Metric Filter  (Make sure "ERROR" "Exception")
![Image](https://github.com/user-attachments/assets/32355817-dedd-412e-8152-bc196f8aef2d)

### 6️⃣ CloudWatch Alarm Configuration
![Image](https://github.com/user-attachments/assets/3fc7f2d5-8a9d-408c-97cf-6e65b9f5bd2c)
 
### 7️⃣ Alarm Graph Visualization
- Graph Analysis:
- Red bars in the bottom timeline and the red alarm state above mean the alarm is in the In alarm state.
- The metric value (ErrorCount-dev) reached the threshold (>= 1), as shown by the rising line crossing the red threshold line.
- CloudWatch detected error logs and triggered the alarm.
![Image](https://github.com/user-attachments/assets/42ce683a-c595-4e10-a6ae-89434f7b702e)

### 8️⃣ Email Subscription Confirmation
![Image](https://github.com/user-attachments/assets/a9576865-a190-4d90-b225-ffe4bff9d3ac)
![Image](https://github.com/user-attachments/assets/33100a88-8e21-40c9-a5d7-6f3aac5b700a)
 
### 🔟 Simulated Error Log Entry
![Image](https://github.com/user-attachments/assets/6b517970-89d2-4f80-a17d-b3a7ab677b28)
 
### 📧 Email Alert Received
![Image](https://github.com/user-attachments/assets/1c02a1cd-36fd-411a-90c3-e7b2bf881034)


#### 🧾 2. Configuration Separation
- Created separate configuration files:
  - `dev_config.json`
  - `prod_config.json`
- These can be injected into EC2 instances during automating.

---

### 🔐 3. Public & Private GitHub Repo Strategy

| Stage  | Repo Type   | Strategy                                                                 |
|--------|-------------|--------------------------------------------------------------------------|
| Dev    | Public Repo | Cloned via `git clone https://github.com/...`                            |
| Prod   | Private Repo| Cloned using a GitHub Token (`https://${token}@github.com/...`)          |

- The provisioning script checks the stage and pulls code from the appropriate repo.

---

### 🔑 4. GitHub Token Handling
- Stored GitHub Personal Access Token (PAT) securely in GitHub Secrets (`GH_PAT`).
- Passed into Terraform as a variable.
- Used only in **prod** provisioning scripts to access the private repo securely.

---

### 📦 5. Stage-Based S3 Log Upload
- Application logs are pushed to stage-specific folders in S3:
  - `s3://<bucket-name>-dev/logs/dev/app.log`
  - `s3://<bucket-name>-prod/logs/prod/app.log`

---

### 🩺 6. Post-Deployment Health Check
- Performs a health check on port `80` after EC2 provisioning.
- Logs success or failure.
- Log file is uploaded to the corresponding S3 bucket.

---

### 1 GitHub Actions Executed
Shows Git tag `deploy-dev` or `deploy-prod` used to start workflow.

![Image](https://github.com/user-attachments/assets/bc396cbb-fc63-4d2f-9980-b2d2809c6451)

---

### 2 EC2 Instances Created
EC2 instance running with tag `app-dev` or `app-prod`.

![Image](https://github.com/user-attachments/assets/c451a533-05de-41ac-aba3-d5379e7b0fc6)

---

### 3 Web App Running in Browser

#### 🌐 Dev App (http://<dev-ip>:80)
![Image](https://github.com/user-attachments/assets/9c53f4a9-87f1-48c2-baec-96cd20d866ec)

#### 🌐 Prod App (http://<prod-ip>:80)
![Image](https://github.com/user-attachments/assets/83082107-8c79-4489-aa63-f1080ad94279)

---

### 4 S3 Logs Stored per Environment

#### 📁 Dev Logs
`s3://tayyaba-devops-app-logs-techeazy-dev/logs/dev/app.log`
![Image](https://github.com/user-attachments/assets/a07a48f1-3c69-4784-90c8-4b03b4e61fa9)

#### 📁 Prod Logs
`s3://tayyaba-devops-app-logs-techeazy-prod/logs/prod/app.log`
![Image](https://github.com/user-attachments/assets/2e96b5e4-ee92-49d2-800c-84de395946e8)

---

### 5 IAM Role & Policy for S3 Write

- Show IAM Role log-writer-role-prod or log-writer-role-dev with policy.

#### 🔒 Dev Role & Policy
#### 🔒 Prod Role & Policy
![Image](https://github.com/user-attachments/assets/6091b030-ac3d-426b-94f1-146e318666a0)
---

### 6 Private Repo Access for Prod
Show in prod_setup.sh the git clone with ${github_token} and token secret in GitHub Secrets.

![Image](https://github.com/user-attachments/assets/126b2ffe-64aa-4aa5-85c8-20472347b0c1)

---

### 7 GitHub Actions Secrets
Show AWS keys and GitHub token stored as secrets.

![Image](https://github.com/user-attachments/assets/61c3f6f5-8ac2-45ec-891f-8d2b0b25bfd7)