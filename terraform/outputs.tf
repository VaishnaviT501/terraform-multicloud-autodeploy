# Load AWS state
data "terraform_remote_state" "aws" {
  backend = "local"
  config = {
    path = "${path.module}/aws/terraform.tfstate"
  }
}

# Load GCP state
data "terraform_remote_state" "gcp" {
  backend = "local"
  config = {
    path = "${path.module}/gcp/terraform.tfstate"
  }
}

# Combined output
output "multi_cloud_public_ips" {
  description = "AWS and GCP public IPs together"
  value = {
    aws = data.terraform_remote_state.aws.outputs.aws_public_ip
    gcp = data.terraform_remote_state.gcp.outputs.gcp_public_ip
  }
}
