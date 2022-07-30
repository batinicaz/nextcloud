data "cloudflare_zone" "tld" {
  count = var.domain_config.enabled ? 1 : 0
  name  = var.domain_config.top_level_domain_name
}

resource "cloudflare_record" "ipv4" {
  count   = var.domain_config.enabled ? 1 : 0
  name    = var.domain_config.subdomain_name
  proxied = true
  ttl     = 1
  type    = "A"
  value   = tolist(linode_instance.instance.ipv4)[0]
  zone_id = data.cloudflare_zone.tld[0].id
}