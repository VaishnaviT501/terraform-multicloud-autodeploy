#!/bin/bash
set -eux

apt-get update -y
apt-get install -y nginx

systemctl enable nginx
systemctl start nginx

echo "<h1>Hello from $(hostname) - deployed by Terraform</h1>" > /var/www/html/index.html
