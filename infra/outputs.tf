output "control_plane_ip_addresses" {
  value = module.control_plane.*.ipv4_address
}
