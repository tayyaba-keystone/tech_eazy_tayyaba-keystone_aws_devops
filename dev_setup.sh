#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

sudo apt update -y
sudo apt install -y openjdk-21-jdk curl unzip git software-properties-common

sudo apt install -y maven || {
  echo "Installing Maven manually..."
  wget https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip
  unzip apache-maven-3.9.6-bin.zip
  sudo mv apache-maven-3.9.6 /opt/maven
  export M2_HOME=/opt/maven
  export PATH=$M2_HOME/bin:$PATH
}

if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

cd /home/ubuntu
git clone https://github.com/techeazy-consulting/techeazy-devops.git
cd techeazy-devops

mvn clean package
nohup $JAVA_HOME/bin/java -jar target/*.jar > app.log 2>&1 &

sleep 30

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

PORT_STATUS=$(curl -s -o /dev/null -w '%%{http_code}' http://$EC2_IP:8080)

if [ "$PORT_STATUS" == "200" ]; then
  echo "✅ App is UP"
else
  echo "❌ App Health Check Failed (code: $PORT_STATUS)"
fi

# ✅ Upload logs to the correct stage-specific bucket
aws s3 cp app.log s3://${bucket}-${stage}/logs/${stage}/app.log
