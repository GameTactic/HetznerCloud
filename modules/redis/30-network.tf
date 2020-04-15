## Service networking

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
