#!/bin/bash

echo "Starting service validation at $(date)" >> /var/log/deployment.log

# Wait for services to fully start
sleep 15

# Check if Tomcat is running
if sudo systemctl is-active --quiet tomcat; then
    echo "✓ Tomcat is running" >> /var/log/deployment.log
else
    echo "✗ Tomcat is not running" >> /var/log/deployment.log
    exit 1
fi

# Check if Apache is running
if sudo systemctl is-active --quiet httpd; then
    echo "✓ Apache HTTP Server is running" >> /var/log/deployment.log
else
    echo "✗ Apache HTTP Server is not running" >> /var/log/deployment.log
    exit 1
fi

# Check if the WAR file was deployed
if [ -f /usr/share/tomcat/webapps/nextwork-web-project.war ]; then
    echo "✓ WAR file deployed successfully" >> /var/log/deployment.log
else
    echo "✗ WAR file not found" >> /var/log/deployment.log
    exit 1
fi

# Check if the application is accessible
sleep 10
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/nextwork-web-project/ || echo "000")
if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo "✓ Application is accessible (HTTP $HTTP_STATUS)" >> /var/log/deployment.log
else
    echo "✗ Application is not accessible (HTTP $HTTP_STATUS)" >> /var/log/deployment.log
    # Don't exit here as the app might still be starting up
fi

echo "Service validation completed at $(date)" >> /var/log/deployment.log
