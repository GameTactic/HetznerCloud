# Output for Manager IPv4
output "manager_ipv4" {
  value = "${hcloud_server.swarm_manager.0.ipv4_address}"
}

# Output for Worker IPv4
#output "worker_ipv4" {
#  value = "${hcloud_server.swarm_worker.*.ipv4_address}"
#}

# Output for domain
output "domain" {
    value = var.gt_domain
}

# Output for cluster
output "cluster" {
    value = var.gt_cluster
}

# Output for FQDN
output "fqdn" {
    value = "${var.gt_cluster}.${var.gt_domain}"
}
