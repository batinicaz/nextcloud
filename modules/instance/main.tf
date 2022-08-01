data "linode_profile" "current" {}

resource "linode_stackscript" "instance_boot_command" {
  count       = var.boot_command != "" ? 1 : 0
  description = "Used to configure the ${var.metadata.instance_name} instance on boot"
  images      = [var.image]
  is_public   = false
  label       = "${var.metadata.instance_name} boot configuration"
  script = templatefile("${path.module}/templates/boot.sh.tmpl", {
    cmd = var.boot_command
  })
}

resource "linode_instance" "instance" {
  #checkov:skip=CKV_LIN_2:Keys are auto added from user
  backups_enabled = var.backups_enabled
  label           = var.metadata.instance_name
  private_ip      = !var.make_public_facing_instance
  region          = var.region
  tags            = [var.metadata.instance_group]
  type            = var.instance_type

  disk {
    image            = var.image
    authorized_users = [data.linode_profile.current.username]
    label            = "boot"
    size             = var.instance_disk_size_gb * 1000 // Need to provide size in MB
    stackscript_id   = var.boot_command != "" ? linode_stackscript.instance_boot_command[0].id : coalesce(var.stack_script_id, null)
  }

  disk {
    label = "swap"
    size  = 1200
  }

  config {
    label  = "boot_config"
    kernel = "linode/latest-64bit"
    devices {
      sda {
        disk_label = "boot"
      }
      sdb {
        disk_label = "swap"
      }
    }
    root_device = "/dev/sda"
  }

  boot_config_label = "boot_config"
}

resource "linode_firewall" "instance_firewall" {
  label           = linode_instance.instance.label
  linodes         = [linode_instance.instance.id]
  inbound_policy  = var.firewall_rules.inbound_policy
  outbound_policy = var.firewall_rules.outbound_policy

  dynamic "inbound" {
    for_each = var.firewall_rules.inbound
    content {
      label    = inbound.value.label
      action   = inbound.value.action
      protocol = inbound.value.protocol
      ports    = inbound.value.ports
      ipv4     = inbound.value.ipv4
      ipv6     = inbound.value.ipv6
    }
  }

  dynamic "outbound" {
    for_each = var.firewall_rules.outbound
    content {
      label    = outbound.value.label
      action   = outbound.value.action
      protocol = outbound.value.protocol
      ports    = outbound.value.ports
      ipv4     = outbound.value.ipv4
      ipv6     = outbound.value.ipv6
    }
  }
}