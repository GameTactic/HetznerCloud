## Infrastructure networking
resource "hcloud_network" "swarm_network" {
  name = "swarm"
  ip_range = "10.0.0.0/8"
}

# Swarm node network
resource "hcloud_network_subnet" "swarm_cluster" {
  network_id = hcloud_network.swarm_network.id
  type = "server"
  network_zone = "eu-central"
  ip_range = "10.0.1.0/24"
}

## Service networking

# Public LoadBalancer Network
resource "docker_network" "gt_public" {
  name        = "gt_public"
  driver      = "overlay"
  ipv6        = false
  ingress     = false
  attachable  = false
  internal    = false
  ipam_config {
    subnet   = "10.0.2.0/24"
    gateway  = "10.0.2.1"
  }
}

# Internal Redis Network
resource "docker_network" "gt_redis" {
  name        = "gt_redis"
  driver      = "overlay"
  ipv6        = false
  ingress     = false
  attachable  = true
  internal    = true
  ipam_config {
    subnet   = "10.0.3.0/24"
    gateway  = "10.0.3.1"
  }
}

# Internal Mysql Network
resource "docker_network" "gt_mysql" {
  name        = "gt_mysql"
  driver      = "overlay"
  ipv6        = false
  ingress     = false
  attachable  = true
  internal    = true
  ipam_config {
    subnet   = "10.0.4.0/24"
    gateway  = "10.0.4.1"
  }
}

