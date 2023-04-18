terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

locals {
  public_key = trimspace(file(var.public_key_path))
}

resource "hcloud_network" "network" {
  name     = var.domain
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = cidrsubnet(hcloud_network.network.ip_range, 8, 1)
}

resource "hcloud_ssh_key" "workstation" {
  name       = "workstation"
  public_key = local.public_key
}
