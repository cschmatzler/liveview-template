terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}

resource "random_string" "server" {
  length  = 5
  lower   = true
  upper   = false
  numeric = true
  special = false
}

locals {
  # General
  # -------
  name = "${var.role}-${random_string.server.id}"

  # SSH
  # ---
  private_key = trimspace(file(var.private_key_path))
  public_key  = trimspace(file(var.public_key_path))
  ssh_args    = "-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.private_key_path}"
}

resource "hcloud_server" "node" {
  name = local.name

  image              = var.image_id
  server_type        = var.node_type
  location           = var.node_location
  placement_group_id = var.placement_group_id

  ssh_keys = var.ssh_keys

  labels    = var.labels
  user_data = var.user_data

  lifecycle {
    ignore_changes = [
      image,
      ssh_keys,
      user_data
    ]
  }
}

resource "hcloud_rdns" "v4" {
  server_id  = hcloud_server.node.id
  ip_address = hcloud_server.node.ipv4_address
  dns_ptr    = format("%s.%s", local.name, var.rdns_domain)
}

resource "hcloud_rdns" "v6" {
  server_id  = hcloud_server.node.id
  ip_address = hcloud_server.node.ipv6_address
  dns_ptr    = format("%s.%s", local.name, var.rdns_domain)
}
