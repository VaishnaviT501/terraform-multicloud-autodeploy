#!/bin/bash
set -eux

# Update & install nginx
sudo yum update -y
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx
sudo systemctl start nginx

# Custom index
echo "<h1>Hello from AWS EC2 - $(hostname) - Terraform Multi-Cloud</h1>" > /usr/share/nginx/html/index.html
