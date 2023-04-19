module "network" {
  source = "./network"

  hcloud_token = var.hcloud_token
  domain       = var.domain
}

module "cluster" {
  source = "./cluster"

  hcloud_token     = var.hcloud_token
  cloudflare_token = var.cloudflare_token
  domain           = var.domain

  network_id = module.network.network_id
  subnet_id  = module.network.cluster_subnet_id

  x86_image_id = var.x86_image_id
  arm_image_id = var.arm_image_id
}
