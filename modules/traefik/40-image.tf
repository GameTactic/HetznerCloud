# Docker Image For the module

resource "docker_image" "img_lb" {
  name = "traefik:v2.1.4"
}
