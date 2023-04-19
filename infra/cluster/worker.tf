module "worker" {
  source   = "./node"
  for_each = local.worker_nodes

  role = "worker"

  node_type          = each.value.node_type
  node_location      = each.value.node_location
  placement_group_id = element(hcloud_placement_group.workers.*.id, ceil(each.value.index / 10))
  image_id           = each.value.image_id

  user_data = file("./worker.yaml")

  ssh_keys         = [var.ssh_key_id]
  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path

  network_id  = var.network_id
  subnet_id   = var.subnet_id
  rdns_domain = local.rdns_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "worker"
  }
}
