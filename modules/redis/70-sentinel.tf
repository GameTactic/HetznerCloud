# Swarm service

resource "docker_service" "sentinel" {
  name = "sentinel"

  task_spec {
    container_spec {
      # Image to run Service
      image = "bitnami/redis-sentinel:latest"

      # Example result: sentinel.eu.gametactic.eu.
      hostname = "sentinel.${var.swarm_fqdn}"

      env = {
        ALLOW_EMPTY_PASSWORD = "yes"
        REDIS_MASTER_HOST = "redis_master"
        REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS = "30"
        REDIS_SENTINEL_QUORUM = "2"
      }
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

  # Run 1 instance on all nodes.
  mode {
    global = true
  }
}
