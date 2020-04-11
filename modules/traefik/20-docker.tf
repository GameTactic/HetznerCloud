# Docker Provider via SSH
# Using Manager

provider "docker" {
  host = "ssh://root@${var.swarm_manager}:22"
}
