#!/bin/bash
# Update the package list
sudo apt-get update -y

# Install Nginx
sudo apt-get install nginx -y

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Start Nginx service
sudo systemctl start nginx

# Create a simple HTML page
echo "<h1>Welcome to your EC2 instance!</h1>" | sudo tee /var/www/html/index.html
