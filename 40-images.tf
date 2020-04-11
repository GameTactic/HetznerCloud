# All Swarm Service Imgaes

resource "docker_image" "img_room" {
  name = "registry.gitlab.com/gametactic/room" 
}

resource "docker_image" "img_socket" {
  name = "registry.gitlab.com/gametactic/socket:latest"
}

resource "docker_image" "img_echo" {
  name = "registry.gitlab.com/gametactic/cpp-echo:0-2"
}

resource "docker_image" "img_user" {
  name = "registry.gitlab.com/gametactic/users:latest"
}

resource "docker_image" "img_auth" {
  name = "registry.gitlab.com/gametactic/authentication:latest"
}

resource "docker_image" "img_lb" {
  name = "traefik:v2.1.4"
}

resource "docker_image" "img_mysql" {
  name = ""
}

resource "docker_image" "img_redis" {
  name = ""
}

resource "docker_image" "img_pma" {
  name = "phpmyadmin/phpmyadmin:latest"
}
