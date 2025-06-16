#!/bin/bash
apt update -y
apt install -y awscli

LOGFILE="/var/log/cloud-init.log"

APPLOG="/home/ubuntu/app/output.log" # Adjust this if app log path  will differs


cat <<EOF > /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload EC2 logs to S3 at shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/bin/aws s3 cp /var/log/cloud-init.log s3://${bucket_name}/ec2-logs/
ExecStart=/usr/bin/aws s3 cp /home/ubuntu/app/output.log s3://${bucket_name}/app/logs/
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target
EOF

systemctl daemon-reexec
systemctl enable upload-logs.service