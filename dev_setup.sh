#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# Export variables passed from Terraform
export stage="${stage}"
export bucket="${bucket}"

# Update system and install dependencies
sudo apt update -y
sudo apt install -y openjdk-21-jdk curl unzip git software-properties-common

# Install Maven if not available
sudo apt install -y maven || {
  echo "Installing Maven manually..."
  wget https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip
  unzip apache-maven-3.9.6-bin.zip
  sudo mv apache-maven-3.9.6 /opt/maven
  export M2_HOME=/opt/maven
  export PATH=$M2_HOME/bin:$PATH
}

# Install AWS CLI if not present
if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

# Set Java path
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Clone and build the application
cd /home/ubuntu
git clone https://github.com/techeazy-consulting/techeazy-devops.git
cd techeazy-devops

mvn clean package
nohup $JAVA_HOME/bin/java -jar target/*.jar > app.log 2>&1 &

# Wait for app to boot
sleep 30

# Get EC2 public IP for health check
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

# ✅ Install CloudWatch Agent manually (standard AWS method)
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# ✅ Create config file for CloudWatch Agent
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/app.log",
            "log_group_name": "/ec2/app-logs-${stage}",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    },
    "log_stream_name": "default"
  }
}
EOF

# ✅ Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# ✅ App health check
PORT_STATUS=$(curl -s -o /dev/null -w '%%{http_code}' http://$EC2_IP:8080)

if [ "$PORT_STATUS" == "200" ]; then
  echo "✅ App is UP"
else
  echo "❌ App Health Check Failed (code: $PORT_STATUS)"
fi

# ✅ Upload logs to S3
aws s3 cp app.log s3://${bucket}-${stage}/logs/${stage}/app.log
