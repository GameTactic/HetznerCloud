# Service Volumes Configuration
resource "docker_volume" "shared_volume" {
  name = "shared_volume"
}
