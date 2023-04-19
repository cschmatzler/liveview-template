packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "talos_version" {
  type    = string
}

variable "arch" {
  type = string
}

locals {
  image = "https://github.com/siderolabs/talos/releases/download/v${var.talos_version}/hcloud-${var.arch}.raw.xz"
}

source "hcloud" "talos" {
  image        = "debian-11"
  rescue       = "linux64"
  location     = "fsn1"
  server_type  = var.arch == "arm64" ? "cax11" : "cx11"
  ssh_username = "root"

  snapshot_name = "talos ${var.talos_version}-${var.arch}"
  snapshot_labels = {
    type    = "infra",
    os      = "talos",
    version = "${var.talos_version}",
    arch = "${var.arch}"
  }
}

build {
  sources = ["source.hcloud.talos"]

  provisioner "shell" {
    inline = [
      "apt-get install -y wget",
      "wget -O /tmp/talos.raw.xz ${local.image}",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
      "partprobe /dev/sda",
      "sfdisk --delete /dev/sda 5",
      "sfdisk --delete /dev/sda 6",
      "gdisk -l /dev/sda"
    ]
  }
}
