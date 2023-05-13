terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.38.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.5.0"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.4"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }

  backend "s3" {
    endpoint                    = "https://s3.eu-central-003.backblazeb2.com"
    region                      = "eu-central-003"
    bucket                      = "liveview-template-app-tfstate"
    force_path_style            = true
    key                         = "infra.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "b2" {
  application_key = var.backblaze_application_key
  application_key_id = var.backblaze_application_key_id
}


locals {
  # Packer
  # ------
  image_id = 110601696

  # Network
  # -------
  domain      = "liveview-template.app"
  rdns_domain = "cluster.${local.domain}"

  # Nodes
  # -----
  control_plane_nodepool = {
    count         = 3
    name          = "control-plane",
    node_type     = "cax11",
    node_location = "fsn1",
    image_id      = local.image_id
  }

  worker_nodepools = [
    {
      count         = 2
      name          = "worker-cax11",
      node_type     = "cax11",
      node_location = "fsn1",
      image_id      = local.image_id
    },
    {
      count         = 2
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
