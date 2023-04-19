module "control_plane" {
  source = "./node"

  role = "control-plane"

  node_type          = local.control_plane_nodes.node_type
  node_location      = local.control_plane_nodes.node_location
  placement_group_id = hcloud_placement_group.control_plane.id
  image_id           = local.control_plane_nodes.image_id

  user_data = file("./controlplane.yaml")

  ssh_keys         = [var.ssh_key_id]
  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path

  network_id  = var.network_id
  subnet_id   = var.subnet_id
  rdns_domain = local.rdns_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "control-plane"
  }
}
