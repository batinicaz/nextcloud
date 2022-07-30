variable "backups_enabled" {
  type    = bool
  default = true
}

variable "boot_command" {
  description = "Optionally provide a command to be run on first boot"
  default     = ""
}

variable "firewall_rules" {
  description = "Optionally configure firewall rules for the created instance, default behaviour is outbound https only - drop all incoming"
  type = object({
    inbound = list(object({
      label    = string
      action   = string
      protocol = string
      ports    = string
      ipv4     = set(string)
      ipv6     = set(string)
    }))
    inbound_policy = string
    outbound = list(object({
      label    = string
      action   = string
      protocol = string
      ports    = string
      ipv4     = set(string)
      ipv6     = set(string)
    }))
    outbound_policy = string
  })
  default = {
    inbound        = []
    inbound_policy = "DROP"
    outbound = [{
      label    = "allow-https"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "443"
      ipv4     = ["0.0.0.0/0"]
      ipv6     = ["::/0"]
    }]
    outbound_policy = "DROP"
  }
}

variable "image" {
  default = "linode/ubuntu22.04"
  type    = string
}

variable "instance_disk_size_gb" {
  type    = number
  default = 50
}

variable "instance_type" {
  type    = string
  default = "g6-standard-1" // Linode 2GB $10/month
}

variable "metadata" {
  type = object({
    instance_name  = string
    instance_group = string
  })
}

variable "make_public_facing_instance" {
  type    = bool
  default = false
}

variable "region" {
  type    = string
  default = "eu-west"
}