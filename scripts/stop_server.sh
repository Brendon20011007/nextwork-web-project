#!/bin/bash

echo "Stopping services at $(date)" >> /var/log/deployment.log

# Stop Apache HTTP Server
isExistApp="$(pgrep httpd)"
if [[ -n $isExistApp ]]; then
    sudo systemctl stop httpd
    echo "Apache HTTP Server stopped at $(date)" >> /var/log/deployment.log
else
    echo "Apache HTTP Server was not running at $(date)" >> /var/log/deployment.log
fi

# Stop Tomcat
isExistApp="$(pgrep java | xargs -I {} ps -p {} -o pid,cmd | grep tomcat)"
if [[ -n $isExistApp ]]; then
    sudo systemctl stop tomcat
    echo "Tomcat stopped at $(date)" >> /var/log/deployment.log
else
    echo "Tomcat was not running at $(date)" >> /var/log/deployment.log
fi

# Remove old WAR file if exists
if [ -f /usr/share/tomcat/webapps/nextwork-web-project.war ]; then
    sudo rm -f /usr/share/tomcat/webapps/nextwork-web-project.war
    echo "Removed old WAR file at $(date)" >> /var/log/deployment.log
fi

# Remove old webapp directory if exists
if [ -d /usr/share/tomcat/webapps/nextwork-web-project ]; then
    sudo rm -rf /usr/share/tomcat/webapps/nextwork-web-project
    echo "Removed old webapp directory at $(date)" >> /var/log/deployment.log
fi

echo "Services stopped successfully at $(date)" >> /var/log/deployment.log
