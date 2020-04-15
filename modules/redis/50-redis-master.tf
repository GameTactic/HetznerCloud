# Swarm service

resource "docker_service" "redis_master" {
  name = "redis_master"

  task_spec {
    container_spec {
      # Image to run Service
      image = docker_image.redis_server.latest

      env = {
        ALLOW_EMPTY_PASSWORD = "yes"
        REDIS_REPLICATION_MODE = "master"
      }

      # Example result: redis.eu.gametactic.eu.
      hostname = "redis.${var.swarm_fqdn}"
    }

    # Logging options
    log_driver {
      name = "json-file"
      options = {
        max-size = "1m"
        max-file = "3"
      }
    }

    # Network connection
    networks = [ docker_network.gt_redis.id ]
  }
}
