packer 
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
  default   = "${env("TF_VAR_hcloud_token")}"
}

variable "talos_version" {
  type    = string
  default = "${env("TALOS_VERSION")}"
}

locals {
  image = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/hcloud-arm64.raw.xz"
}

source "hcloud" "talos" {
  token        = var.hcloud_token
  image        = "debian-11"
  rescue       = "linux64"
  location     = "fsn1"
  server_type  = "cax11"
  ssh_username = "root"

  snapshot_name = "talos ${var.talos_version}"
  snapshot_labels = {
    type    = "infra",
    os      = "talos",
    version = "${var.talos_version}"
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
