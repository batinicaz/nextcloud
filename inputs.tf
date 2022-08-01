// Opted to not create the key in TF as would then need a provider with permissions to create tokens
variable "cloudflare_api_key" {
  description = "Existing API key that has permission to create DNS records in CloudFlare"
  type        = string
  sensitive   = true
}

variable "image" {
  type    = string
  default = "linode/ubuntu22.04"
}

variable "instance_type" {
  type    = string
  default = "g6-standard-2" // Linode 4GB $20/month
}

variable "top_level_domain" {
  description = "A domain that is currently being managed by cloudflare"
  type        = string
}

variable "sub_domain" {
  description = "The sub domain on which nextcloud will be accessible"
  default     = "nextcloud"
}

variable "ubuntu_advantage_key" {
  description = "If provided Ubuntu Advantage will be configured on boot"
  type        = string
  default     = ""
  sensitive   = true
}

locals {
  nextcloud_domain = "${var.sub_domain}.${var.top_level_domain}"
}