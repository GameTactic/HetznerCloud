# Docker Image For the module

resource "docker_image" "traefik" {
  name = "traefik:v2.1.9"
}
