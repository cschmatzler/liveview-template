output "control_plane_ip_addresses" {
  value = module.control_plane.*.ipv4_address
}

output "worker_ip_addresses" {
  value = flatten([for nodepool in module.workers : nodepool.*.ipv4_address])
}
