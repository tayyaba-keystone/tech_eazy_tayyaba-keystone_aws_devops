#!/bin/bash

BUCKET_NAME=$1  # <== Make sure to capture the bucket name from input

# Use sudo for privileged commands
sudo apt update -y
sudo apt install -y awscli

LOGFILE="/var/log/cloud-init.log"
APPLOG="/home/ubuntu/app/output.log"  # Adjust if needed

# Create a systemd service to upload logs at shutdown
sudo bash -c "cat <<EOF > /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload EC2 logs to S3 at shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/bin/aws s3 cp $LOGFILE s3://$BUCKET_NAME/ec2-logs/
ExecStart=/usr/bin/aws s3 cp $APPLOG s3://$BUCKET_NAME/app/logs/
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target
EOF"

sudo systemctl daemon-reexec
sudo systemctl enable upload-logs.service
