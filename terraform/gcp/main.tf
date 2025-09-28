terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file("D:/Elevate_Labs/Projects/terraform-multicloud-autodeploy/key.json")
  project     = "terraform-multicloud-lab"
  region      = "us-central1"
  zone        = "us-central1-a"  
}
variable "gcp_machine_type" {
  description = "GCP VM machine type"
  default     = "e2-micro"
}

variable "gcp_zone" {
  description = "GCP zone"
  default     = "us-central1-a"
}

# GCP Compute Instance
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
    access_config {}  # Assigns a public IP
  }

  metadata_startup_script = file("${path.module}/../../scripts/install_nginx.sh")
  tags                    = ["http-server", "https-server"]
}

# Firewall to allow HTTP/HTTPS
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

# Output public IP
output "gcp_public_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}
