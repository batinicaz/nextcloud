module "linode" {
  source = "./modules/instance"

  firewall_rules = {
    inbound = [{
      label    = "allow-public-https-ingress-ipv4-only"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "443"
      ipv4     = ["0.0.0.0/0"]
      ipv6     = []
    }]
    inbound_policy = "DROP"
    outbound = [{
      label    = "allow-https-egress"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "443"
      ipv4     = ["0.0.0.0/0"]
      ipv6     = ["::/0"]
    }]
    outbound_policy = "DROP"
  }
  make_public_facing_instance = true
  metadata = {
    instance_name  = "Nextcloud"
    instance_group = "Productivity"
  }
}