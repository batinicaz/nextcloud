data "cloudflare_ip_ranges" "cloudflare" {}

module "linode" {
  source       = "./modules/instance"
  boot_command = "snap install nextcloud && snap run nextcloud.enable-https self-signed"
  domain_config = {
    top_level_domain_name = "batinica.org"
    subdomain_name        = "nextcloud"
    enabled               = true
  }
  firewall_rules = {
    inbound = [{
      label    = "allow-https-from-cloudflare"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "443"
      ipv4     = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
      ipv6     = data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks
    }]
    inbound_policy = "DROP"
    outbound = [{
      label    = "allow-https-egress"
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "443"
      ipv4     = ["0.0.0.0/0"]
      ipv6     = ["::/0"]
      },
      {
        label    = "allow-dns-lookup"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "53"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
      }
    ]
    outbound_policy = "DROP"
  }
  make_public_facing_instance = true
  metadata = {
    instance_name  = "Nextcloud"
    instance_group = "Productivity"
  }
}