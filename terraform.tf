terraform {
  backend "s3" {
    endpoint                    = "eu-central-1.linodeobjects.com"
    bucket                      = "batinica-terraform-state"
    key                         = "linode/terraform.json"
    region                      = "eu-central-1"
    skip_credentials_validation = true // If false would try and talk to AWS STS
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    linode = {
      source  = "linode/linode"
      version = "~> 1.28"
    }
  }
  required_version = "~> 1.2"
}