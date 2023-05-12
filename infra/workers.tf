resource "hcloud_placement_group" "workers" {
  count = ceil(local.worker_count / 10)

  name = "workers-${count.index + 1}"
  type = "spread"
}

module "workers" {
  source   = "./node"
  for_each = local.worker_nodes

  role = "worker"

  node_type          = each.value.node_type
  node_location      = each.value.node_location
  placement_group_id = element(hcloud_placement_group.workers.*.id, ceil(each.value.index / 10))
  image_id           = each.value.image_id

  user_data = file("./talos/worker.yaml")

  network_id  = hcloud_network.network.id
  subnet_id   = hcloud_network_subnet.cluster.id
  ipv4_enabled = false
  rdns_domain = local.rdns_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "worker"
  }
}
