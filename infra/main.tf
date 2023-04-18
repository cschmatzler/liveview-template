module "network" {
  source = "./network"

  hcloud_token = var.hcloud_token
  domain = var.domain

  public_key_path = var.public_key_path
}

module "cluster" {
  source = "./cluster"

  hcloud_token = var.hcloud_token
  cloudflare_token = var.cloudflare_token
  domain = var.domain

  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path
  ssh_key_id       = module.network.ssh_key_id

  network_id = module.network.network_id
  subnet_id  = module.network.cluster_subnet_id

  image_id = var.image_id
}
