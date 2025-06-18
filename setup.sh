#!/bin/bash

BUCKET_NAME=$1  # Get bucket name as argument

# Retry apt update in case of lock issues
for i in {1..5}; do
  sudo apt update -y && break || sleep 10
done

# Try installing awscli using apt
for i in {1..5}; do
  sudo apt install -y awscli && break || sleep 10
done

# If aws not installed, fallback to pip
if ! command -v aws &> /dev/null; then
  echo "apt failed, trying pip to install awscli"
  sudo apt install -y python3-pip unzip
  pip3 install awscli --upgrade --user
  export PATH=$PATH:/home/ubuntu/.local/bin
fi

# Confirm aws is installed
aws --version

# Setup systemd shutdown service
sudo bash -c "cat <<EOF > /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload EC2 logs to S3 at shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/bin/aws s3 cp /var/log/cloud-init.log s3://$BUCKET_NAME/ec2-logs/
ExecStart=/usr/bin/aws s3 cp /home/ubuntu/app/output.log s3://$BUCKET_NAME/app/logs/
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target
EOF"

sudo systemctl daemon-reexec
sudo systemctl enable upload-logs.service

# Optional: Automatically shut down after 2 minutes (adjust if needed)
sudo shutdown -h +2
