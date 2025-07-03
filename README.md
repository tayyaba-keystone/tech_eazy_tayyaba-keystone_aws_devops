# 🚀 DevOps Assignment 5 – Log Streaming, CloudWatch Alarm & SNS Email Alert

This project automates the provisioning of an AWS EC2 instance using Terraform and deploys a Spring Boot application. It then streams logs to CloudWatch, sets up metric filters and alarms on error patterns, and sends alerts to email via SNS.

---

## 🔁 Output Flow & Screenshot Sequence
## 📸 Screenshots
### 1️⃣ EC2 Instance Running
![EC2 Running](screenshots/2_ec2_running.png)
 
### 2️⃣ Application Up Check (Port 8080)
![App Up](screenshots/3_app_up_check.png)
 ### 3️⃣ CloudWatch Log Group Visible
![Log Group](screenshots/4_log_group_view.png)
 
### 4️⃣ Log Stream Entries in CloudWatch
![Log Stream](screenshots/5_log_stream_entries.png)
 
### 5️⃣ CloudWatch Metric Filter  (Make sure "ERROR" "Exception")
![Metric Filter](screenshots/6_metric_filter_created.png)
 
### 6️⃣ CloudWatch Alarm Configuration
![Alarm Configuration](screenshots/7_cloudwatch_alarm_config.png)
 
### 7️⃣ Alarm Graph Visualization
![Alarm Graph](screenshots/8_alarm_graph.png)

### 8️⃣ Email Subscription Confirmation
![SNS Subscription Email](screenshots/9_email_subscription_confirmed.png)

### 🔟 Simulated Error Log Entry
![Simulated Error Log](screenshots/10_simulated_error_log.png)

### 🔔 Alarm Triggered
![Alarm Triggered](screenshots/11_alarm_triggered.png)

### 📧 Email Alert Received
![Email Alert](screenshots/12_alarm_email_received.png)
