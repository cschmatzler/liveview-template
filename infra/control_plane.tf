resource "hcloud_placement_group" "control_plane" {
  name = "control-plane"
  type = "spread"
}

module "control_plane" {
  source = "./node"
  count  = local.control_plane_nodes.count

  role = "control-plane"

  node_type          = local.control_plane_nodes.node_type
  node_location      = local.control_plane_nodes.node_location
  placement_group_id = hcloud_placement_group.control_plane.id
  image_id           = local.control_plane_nodes.image_id

  user_data = file("./talos/controlplane.yaml")

  network_id  = hcloud_network.network.id
  subnet_id   = hcloud_network_subnet.cluster.id
  rdns_domain = local.rdns_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "control-plane"
  }
}
