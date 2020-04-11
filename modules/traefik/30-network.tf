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

#############################################################
## Commented out due these should be on their own modules. ##
## Niko just could not find time yet to create them.       ##
#############################################################

# Internal Redis Network
#resource "docker_network" "gt_redis" {
#  name        = "gt_redis"
#  driver      = "overlay"
#  ipv6        = false
#  ingress     = false
#  attachable  = true
#  internal    = true
#  ipam_config {
#    subnet   = "10.0.3.0/24"
#    gateway  = "10.0.3.1"
#  }
#}

# Internal Mysql Network
#resource "docker_network" "gt_mysql" {
#  name        = "gt_mysql"
#  driver      = "overlay"
#  ipv6        = false
#  ingress     = false
#  attachable  = true
#  internal    = true
#  ipam_config {
#    subnet   = "10.0.4.0/24"
#    gateway  = "10.0.4.1"
#  }
#}

