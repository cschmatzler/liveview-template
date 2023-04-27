output "network_id" {
  value = hcloud_network.network.id
}

output "cluster_subnet_id" {
  value = hcloud_network_subnet.cluster.id
}
