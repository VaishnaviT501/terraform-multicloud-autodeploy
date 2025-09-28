# AWS Provider
provider "aws" {
  region = "us-east-1"  # AWS Region (not AZ)
}

# Variables
variable "aws_instance_type" {
  description = "AWS EC2 instance type"
  default     = "t3.micro"
}

variable "aws_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "tf-web-sg"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami               = var.aws_ami
  instance_type     = var.aws_instance_type
  availability_zone = "us-east-1b"         # Optional: can remove to let AWS pick default
  security_groups   = [aws_security_group.web_sg.name]

  # Optional user_data for NGINX installation
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Hello from Terraform AWS Web Server</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "tf-web-aws"
  }
}

# Output public IP
output "aws_public_ip" {
  value = aws_instance.web.public_ip
}
