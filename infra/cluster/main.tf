terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

locals {
  # SSH
  # ---
  private_key = trimspace(file(var.private_key_path))
  public_key  = trimspace(file(var.public_key_path))

  # Network
  # -------
  rdns_domain = "cluster.${var.domain}"

  # Nodes
  # -----
  control_plane_nodes = {
    count         = 1
    name          = "control-plane",
    node_type     = "cx11",
    node_location = "fsn1",
  }

  worker_nodepools = [
    {
      count         = 3
      name          = "worker-cx11",
      node_type     = "cx11",
      node_location = "fsn1",
    },
  ]

  # Servers
  # -----
  worker_count = sum([for v in local.worker_nodepools : v.count])
  worker_nodes = merge([
    for pool_index, nodepool in local.worker_nodepools : {
      for node_index in range(nodepool.count) :
      format("%s-%s-%s", pool_index, node_index, nodepool.name) => {
        index : node_index,
        nodepool_name : nodepool.name,
        node_type : nodepool.node_type,
        node_location : nodepool.node_location
      }
    }
  ]...)
}

resource "hcloud_placement_group" "control_plane" {
  name = "control-plane"
  type = "spread"
}

resource "hcloud_placement_group" "workers" {
  count = ceil(local.worker_count / 10)

  name = "workers-${count.index + 1}"
  type = "spread"
}

data "cloudflare_zone" "domain" {
  name = var.domain
}

resource "cloudflare_record" "control_plane_v4" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "A"
  ttl     = 60
  name    = "cluster"
  value   = module.control_plane.ipv4_address
}

resource "cloudflare_record" "control_plane_v6" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "AAAA"
  ttl     = 60
  name    = "cluster"
  value   = module.control_plane.ipv6_address
}
