#!/bin/bash
apt update -y
apt install -y awscli

LOGFILE="/var/log/cloud-init.log"
APPLOG="/var/www/html/app.log"  # Adjust this if app log path differs

cat <<EOF > /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload EC2 logs to S3 at shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/bin/aws s3 cp $LOGFILE s3://${bucket_name}/ec2-logs/
ExecStart=/usr/bin/aws s3 cp $APPLOG s3://${bucket_name}/app/logs/
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target
EOF

systemctl daemon-reexec
systemctl enable upload-logs.service
