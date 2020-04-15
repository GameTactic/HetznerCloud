# Docker Image For the module

resource "docker_image" "redis_server" {
  name = "bitnami/redis:latest"
}

resource "docker_image" "redis_sentinel" {
  name = "bitnami/redis-sentinel:latest"
}
