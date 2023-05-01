terraform {
  cloud {
    organization = "liveview-template"

    workspaces {
      name = "liveview-template"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0.0"
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
  # Packer
  # ------
  image_id = 109031096

  # Network
  # -------
  domain      = "liveview-template.app"
  rdns_domain = "cluster.${local.domain}"

  # Nodes
  # -----
  control_plane_nodes = {
    count         = 3
    name          = "control-plane",
    node_type     = "cax11",
    node_location = "fsn1",
    image_id      = local.image_id
  }

  worker_nodepools = [
    {
      count         = 3
      name          = "worker-cax21",
      node_type     = "cax21",
      node_location = "fsn1",
      image_id      = local.image_id
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
        node_location : nodepool.node_location,
        image_id : nodepool.image_id
      }
    }
  ]...)
}
