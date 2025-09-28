#!/bin/bash
set -eux

# Update & install nginx
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Custom index
echo "<h1>Hello from GCP VM - $(hostname) - Terraform Multi-Cloud</h1>" > /var/www/html/index.html
