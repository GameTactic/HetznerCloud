# Docker Provider via SSH
# Using Manager

provider "docker" {
  host = "ssh://root@${hcloud_server.swarm_manager.0.ipv4_address}:22"
}
