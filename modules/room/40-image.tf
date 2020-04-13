# Docker Image For the module

resource "docker_image" "gt_room" {
  name = "registry.gitlab.com/gametactic/room:develop"
}
