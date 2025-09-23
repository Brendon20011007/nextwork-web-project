#!/bin/bash

echo "Starting services at $(date)" >> /var/log/deployment.log

# Start Tomcat
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Wait for Tomcat to start
sleep 10

# Start Apache HTTP Server
sudo systemctl start httpd
sudo systemctl enable httpd

# Check if services are running
if sudo systemctl is-active --quiet tomcat; then
    echo "Tomcat started successfully at $(date)" >> /var/log/deployment.log
else
    echo "Failed to start Tomcat at $(date)" >> /var/log/deployment.log
    exit 1
fi

if sudo systemctl is-active --quiet httpd; then
    echo "Apache HTTP Server started successfully at $(date)" >> /var/log/deployment.log
else
    echo "Failed to start Apache HTTP Server at $(date)" >> /var/log/deployment.log
    exit 1
fi

echo "All services started successfully at $(date)" >> /var/log/deployment.log
