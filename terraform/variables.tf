# AWS Variables
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_instance_type" {
  description = "AWS EC2 instance type"
  default     = "t3.micro"
}

# GCP Variables
variable "gcp_project" {
  description = "GCP project ID"
  default     = "terraform-multicloud-lab"
}

variable "gcp_region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default     = "us-central1-a"
}

variable "gcp_machine_type" {
  description = "GCP VM machine type"
  default     = "e2-micro"
}
