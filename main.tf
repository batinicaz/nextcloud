data "cloudflare_ip_ranges" "cloudflare" {}

resource "linode_stackscript" "nextcloud" {
  description = "Used to configure nextcloud on first boot"
  images      = [var.image]
  is_public   = false
  label       = "Nextcloud"
  script = templatefile("${path.module}/templates/first-boot.sh.tmpl", {
    api_key       = var.cloudflare_api_key
    domain        = local.nextcloud_domain
    livepatch_key = var.livepatch_key
  })
}

module "linode" {
  source = "./modules/instance"
  domain_config = {
    top_level_domain_name = var.top_level_domain
    subdomain_name        = var.sub_domain
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
    outbound = [
      {
        label    = "allow-http-egress"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "80" // apt packages
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
      },
      {
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
  image                       = var.image
  instance_type               = var.instance_type
  make_public_facing_instance = true
  metadata = {
    instance_name  = "Nextcloud"
    instance_group = "Productivity"
  }
  stack_script_id = linode_stackscript.nextcloud.id
}