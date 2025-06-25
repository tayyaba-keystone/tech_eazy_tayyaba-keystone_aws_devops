## ✅ Assignment 4 – Parameterized Multi-Stage Deployment (DevOps)

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
- Performs a health check on port `8080` after EC2 provisioning.
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
