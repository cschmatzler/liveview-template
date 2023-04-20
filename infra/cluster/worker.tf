module "worker" {
  source   = "./node"
  for_each = local.worker_nodes

  role = "worker"

  node_type          = each.value.node_type
  node_location      = each.value.node_location
  placement_group_id = element(hcloud_placement_group.workers.*.id, ceil(each.value.index / 10))
  image_id           = each.value.image_id

  user_data = file("./worker.yaml")

  network_id  = var.network_id
  subnet_id   = var.subnet_id
  rdns_domain = local.rdns_domain

  ipv4_enabled = false

  labels = {
    "provisioner" = "terraform",
    "role"        = "worker"
  }
}
