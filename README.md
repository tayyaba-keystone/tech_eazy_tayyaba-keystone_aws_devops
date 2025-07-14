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
