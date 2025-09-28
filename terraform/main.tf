terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# ---------------- AWS Provider ----------------
provider "aws" {
  region = var.aws_region
}

# ---------------- GCP Provider ----------------
provider "google" {
  credentials = file("D:/Elevate_Labs/Projects/terraform-multicloud-autodeploy/key.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

# ---------------- AWS EC2 ----------------
resource "aws_security_group" "web_sg" {
  name        = "tf-web-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.aws_instance_type
  key_name      = "your-key-name"  # optional
  security_groups = [aws_security_group.web_sg.name]

  user_data = file("${path.module}/aws/install_nginx.sh")

  tags = {
    Name = "tf-web-aws"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ---------------- GCP Compute ----------------
resource "google_compute_instance" "web" {
  name         = "tf-web-gcp"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("${path.module}/gcp/install_nginx.sh")
  tags                    = ["http-server", "https-server"]
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}
