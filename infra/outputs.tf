output "control_plane_ip_addresses" {
  value = module.control_plane.*.ipv4_address
}

output "worker_ip_addresses" {
  value = flatten([for nodepool in module.workers : nodepool.*.ipv4_address])
}

output "mimir_application_key" {
  value = "${module.mimir_bucket.aws_access_key_id}:${module.mimir_bucket.aws_secret_access_key}"
  sensitive = true
}

output "loki_application_key" {
  value = "${module.loki_bucket.aws_access_key_id}:${module.loki_bucket.aws_secret_access_key}"
  sensitive = true
}

output "tempo_application_key" {
  value = "${module.tempo_bucket.aws_access_key_id}:${module.tempo_bucket.aws_secret_access_key}"
  sensitive = true
}
