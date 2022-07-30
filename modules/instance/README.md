# Linode Instance

Simple TF module for provisioning a Linode instance with a firewall.

By default, will provision a Linode 2GB ($10/month) instance running Ubuntu 22.04 that has ssh allowed from any keys 
linked to the account running the module.

Note: Default Firewall rules only allow https egress (no ingress) so while ssh is autoconfigured for any keys linked to 
the account running the module, without modifying the firewall config ssh access is not possible.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_linode"></a> [linode](#requirement\_linode) | ~> 1.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_linode"></a> [linode](#provider\_linode) | ~> 1.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [linode_firewall.instance_firewall](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/firewall) | resource |
| [linode_instance.instance](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance) | resource |
| [linode_stackscript.instance_boot_command](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/stackscript) | resource |
| [linode_profile.current](https://registry.terraform.io/providers/linode/linode/latest/docs/data-sources/profile) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backups_enabled"></a> [backups\_enabled](#input\_backups\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_boot_command"></a> [boot\_command](#input\_boot\_command) | Optionally provide a command to be run on first boot | `string` | `""` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Optionally configure firewall rules for the created instance, default behaviour is outbound https only - drop all incoming | <pre>object({<br>    inbound = list(object({<br>      label    = string<br>      action   = string<br>      protocol = string<br>      ports    = string<br>      ipv4     = set(string)<br>      ipv6     = set(string)<br>    }))<br>    inbound_policy = string<br>    outbound = list(object({<br>      label    = string<br>      action   = string<br>      protocol = string<br>      ports    = string<br>      ipv4     = set(string)<br>      ipv6     = set(string)<br>    }))<br>    outbound_policy = string<br>  })</pre> | <pre>{<br>  "inbound": [],<br>  "inbound_policy": "DROP",<br>  "outbound": [<br>    {<br>      "action": "ACCEPT",<br>      "ipv4": [<br>        "0.0.0.0/0"<br>      ],<br>      "ipv6": [<br>        "::/0"<br>      ],<br>      "label": "allow-https",<br>      "ports": "443",<br>      "protocol": "TCP"<br>    }<br>  ],<br>  "outbound_policy": "DROP"<br>}</pre> | no |
| <a name="input_image"></a> [image](#input\_image) | n/a | `string` | `"linode/ubuntu22.04"` | no |
| <a name="input_instance_disk_size_gb"></a> [instance\_disk\_size\_gb](#input\_instance\_disk\_size\_gb) | n/a | `number` | `50` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"g6-standard-1"` | no |
| <a name="input_make_public_facing_instance"></a> [make\_public\_facing\_instance](#input\_make\_public\_facing\_instance) | n/a | `bool` | `false` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | n/a | <pre>map(object({<br>    instance_name  = string<br>    instance_group = string<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->