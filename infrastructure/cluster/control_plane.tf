module "control_plane" {
  source = "./node"
  count  = local.control_plane_nodes.count

  role = "control-plane"

  node_type          = local.control_plane_nodes.node_type
  node_location      = local.control_plane_nodes.node_location
  placement_group_id = hcloud_placement_group.control_plane.id
  image_id           = local.control_plane_nodes.image_id

  user_data = file("./talos/controlplane.yaml")

  network_id  = var.network_id
  subnet_id   = var.subnet_id
  rdns_domain = local.rdns_domain

  labels = {
    "provisioner" = "terraform",
    "role"        = "control-plane"
  }
}

resource "hcloud_load_balancer" "control_plane" {
  name               = "cluster.liveview-template.app"
  load_balancer_type = "lb11"
  location           = "fsn1"
}

resource "hcloud_load_balancer_service" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_network" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  network_id       = var.network_id
}

resource "hcloud_load_balancer_target" "control_plane" {
  count = local.control_plane_nodes.count

  type             = "server"
  load_balancer_id = hcloud_load_balancer.control_plane.id
  server_id        = module.control_plane[count.index].server_id
}
