data "cloudflare_zone" "domain" {
  name = local.domain
}

resource "hcloud_firewall" "kubernetes" {
  name = "kubernetes"
  rule {
    description = "Control Plane"
    direction   = "in"
    protocol    = "tcp"
    port        = 6443
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Talos API"
    direction   = "in"
    protocol    = "tcp"
    port        = 50000
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Outgoing traffic/TCP"
    direction   = "out"
    protocol    = "tcp"
    port        = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    description = "Outgoing traffic/UDP"
    direction   = "out"
    protocol    = "udp"
    port        = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "kubernetes" {
  firewall_id = hcloud_firewall.kubernetes.id
  server_ids  = concat(module.control_plane.*.server_id, flatten([for nodepool in module.workers : nodepool.*.server_id]))
}

resource "hcloud_network" "network" {
  name     = "cluster.${local.domain}"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = cidrsubnet(hcloud_network.network.ip_range, 8, 1)
}

resource "hcloud_load_balancer" "control_plane" {
  name               = "cluster.${local.domain}"
  load_balancer_type = "lb11"
  location           = "fsn1"
}

resource "hcloud_load_balancer_service" "kubernetes" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_service" "talos" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 50000
  destination_port = 50000
}

resource "hcloud_load_balancer_network" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  network_id       = hcloud_network.network.id
}

resource "hcloud_load_balancer_target" "control_plane" {
  count = local.control_plane_nodepool.count

  type             = "server"
  load_balancer_id = hcloud_load_balancer.control_plane.id
  server_id        = module.control_plane[count.index].server_id
}

resource "cloudflare_record" "control_plane_v4" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "A"
  ttl     = 60
  name    = "cluster"
  value   = hcloud_load_balancer.control_plane.ipv4
}

resource "cloudflare_record" "control_plane_v6" {
  zone_id = data.cloudflare_zone.domain.id
  type    = "AAAA"
  ttl     = 60
  name    = "cluster"
  value   = hcloud_load_balancer.control_plane.ipv6
}
