#!/bin/bash

# Update system packages
sudo yum update -y

# Enable Amazon Linux Extras and install PHP
sudo amazon-linux-extras enable php8.0
sudo yum install -y httpd php php-mysqlnd

# Start and enable Apache HTTP server
sudo systemctl enable httpd
sudo systemctl start httpd

# Set up the web directory with proper permissions
sudo mkdir -p /var/www/html
sudo chown -R ec2-user:ec2-user /var/www/html
sudo chmod -R 775 /var/www/html

# Create a flag file to indicate user-data completion
echo "User data execution completed" | sudo tee /tmp/userdata_done