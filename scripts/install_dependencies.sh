#!/bin/bash

# Log deployment start
echo "Starting deployment at $(date)" >> /var/log/deployment.log

# Install Java 8 if not present
if ! java -version 2>&1 | grep -q "1.8.0"; then
    sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
fi

# Install Tomcat
sudo yum install -y tomcat

# Install Apache HTTP Server
sudo yum install -y httpd

# Create Tomcat directory if it doesn't exist
sudo mkdir -p /usr/share/tomcat/webapps

# Configure Apache for reverse proxy
sudo cat << EOF > /etc/httpd/conf.d/tomcat_manager.conf
<VirtualHost *:80>
  ServerAdmin root@localhost
  ServerName app.nextwork.com
  DefaultType text/html
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://localhost:8080/nextwork-web-project/
  ProxyPassReverse / http://localhost:8080/nextwork-web-project/
</VirtualHost>
EOF

# Enable proxy modules
sudo sh -c 'echo "LoadModule proxy_module modules/mod_proxy.so" >> /etc/httpd/conf/httpd.conf'
sudo sh -c 'echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> /etc/httpd/conf/httpd.conf'

# Set correct permissions
sudo chown -R tomcat:tomcat /usr/share/tomcat/webapps/
sudo chmod -R 755 /usr/share/tomcat/webapps/

echo "Dependencies installation completed at $(date)" >> /var/log/deployment.log
