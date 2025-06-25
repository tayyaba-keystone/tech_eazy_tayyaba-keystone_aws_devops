## ✅ Parameterized Multi-Stage Deployment (DevOps)

This project demonstrates a **multi-stage deployment pipeline** using **Terraform** and **GitHub Actions**, supporting dynamic environments for both `dev` and `prod`.

---

### 🚀 Features Implemented

#### 🧩 1. Stage-Based Infrastructure Deployment
- Used `Terraform` input variables and GitHub tags to manage multiple stages.
- Triggered by:
  - `deploy-dev` → Deploys `dev` infrastructure.
  - `deploy-prod` → Deploys `prod` infrastructure.

#### 🧾 2. Configuration Separation
- Created separate configuration files:
  - `dev_config.json`
  - `prod_config.json`
- These can be injected into EC2 instances during provisioning.

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

### 🧪 How to Trigger Deployment

```bash
# Deploy to Dev
git tag deploy-dev
git push origin deploy-dev

# Deploy to Prod
git tag deploy-prod
git push origin deploy-prod

## 📸 Screenshots

---
### 1 GitHub Actions Executed
Shows Git tag `deploy-dev` or `deploy-prod` used to start workflow.

![Image](https://github.com/user-attachments/assets/2b4a3923-bb1c-4a4d-b941-f66fcde5123c)

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
