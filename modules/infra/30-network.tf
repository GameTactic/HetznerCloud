## Infrastructure networking
resource "hcloud_network" "swarm_network" {
  name = "swarm-${var.gt_cluster}"
  ip_range = "10.0.0.0/8"
}

# Swarm node network
resource "hcloud_network_subnet" "swarm_cluster" {
  network_id = hcloud_network.swarm_network.id
  type = "server"
  network_zone = "eu-central"
  ip_range = "10.0.1.0/24"
}
