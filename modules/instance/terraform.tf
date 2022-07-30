terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.28"
    }
  }
  required_version = "~> 1.2"
}