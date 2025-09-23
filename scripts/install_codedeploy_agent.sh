#!/bin/bash

# Install CodeDeploy Agent for Amazon Linux 2
# This script should be run on your EC2 instance

# Update system
sudo yum update -y

# Install Ruby (required for CodeDeploy agent)
sudo yum install -y ruby wget

# Download and install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-1.s3.ap-northeast-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Start and enable CodeDeploy agent
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent

# Verify installation
sudo systemctl status codedeploy-agent

echo "CodeDeploy agent installation completed"
