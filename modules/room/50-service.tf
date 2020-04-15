# Swarm service

resource "docker_service" "room" {
  name = "room"

  # Rest of it is configured via Labels.
  labels {
  # Unleash the Traefik
    label = "traefik.enable"
    value = "true"
  }

  labels {
    # Port we use to access this service.
    label = "traefik.http.services.room.loadbalancer.server.port"
    value = "80"
  }

  labels {
    # Public domain to access this service. (SSL)
    label = "traefik.http.routers.room-ssl.rule"
    value = "Host(`room.${var.swarm_fqdn}`)"
  }

  labels {
    # Enable HTTPS on previous endpoint
    label = "traefik.http.routers.room-ssl.tls"
    value = "true"
  }

  labels {
    # Use Lets Encrypt to resolve
    label = "traefik.http.routers.room-ssl.tls.certresolver"
    value = "true"
  }

  labels {
    # Set SSL endpoint for specific router.
    label = "traefik.http.routers.room-ssl.entrypoints"
    value = "websecure"
  }

  labels {
    # Public domain to access this service.
    label = " traefik.http.routers.room.rule"
    value = "Host(`room.${var.swarm_fqdn}`)"
  }

  labels {
    # Set SSL endpoint for specific router.
    label = "traefik.http.routers.room.entrypoints"
    value = "web"
  }

  task_spec {
    container_spec {
      # Image to run Service
      image = "registry.gitlab.com/gametactic/room:develop"

      # Hostname. Example result: room.eu.gametactic.eu.
      hostname = "room.${var.swarm_fqdn}"
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
    networks = [ var.lb_network ]
  }

  mode {
    replicated {
      replicas = 3
    }
  }
}
