# Swarm service

resource "docker_service" "traefik" {
  name = "traefik"

  # Rest of it is configured via Labels.
  labels {
    # Unleash the Traefik
    label = "traefik.enable"
    value = "true"
  }

  labels {
    # Api Entrypoint Https Only
    label = "traefik.http.routers.api.entrypoints"
    value = "websecure"
  }

  labels {
    # Api Entrypoint via lb.cluster.domain.
    label = "traefik.http.routers.api.rule"
    value = "Host(`lb.${var.swarm_fqdn}`)"
  }

  labels {
    # Api Service to use.
    label = "traefik.http.routers.api.service"
    value = "api@internal"
  }

  labels {
    # https://stackoverflow.com/questions/58580782/traefik-2-0-port-is-missing-for-internal-dashboard
    label = "traefik.http.services.justAdummyService.loadbalancer.server.port"
    value = "1337"
  }

  labels {
    # Authentication Middleware for API
    label = "traefik.http.routers.api.middlewares"
    value = "auth-dash"
  }

  #labels {
    # Authentication credentials for Traefik Dashboard
    # TODO!
  #  label = "traefik.http.middlewares.auth-dash.basicauth.user"
  #  value = ""
  #}

  labels {
    # Use Let's Encrypt for API Cert
    label = "traefik.http.routers.api.tls.certresolver"
    value = "le"
  }

  labels {
    # Redirect http to https.
    label = "traefik.http.routers.http-catchall.middlewares"
    value = "redirect-to-https@docker"
  }

  labels {
    # Regex to catch http calls to be redirected to https.
    label = "traefik.http.routers.http-catchall.rule"
    value = "hostregexp(`{host:.+}`)"
  }

  labels {
    # Entrypoints to catch for https redirection.
    label = "traefik.http.routers.http-catchall.entrypoints"
    value = "web"
  }

  labels {
    # Enable redirect middleware
    label = "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme"
    value = "https"
  }

  labels {
    # API HTTPS
    label = "traefik.http.routers.api.tls"
    value = "true"
  }

  task_spec {
    container_spec {
      # Image to run Service
      image = "traefik:v2.1.9"

      # Traefik v2 is configured mainly via command.
      command = [
        "traefik",
        "--providers.docker.endpoint=unix:///var/run/docker.sock",
        "--providers.docker.swarmMode=true",
        "--providers.docker.exposedbydefault=false",
        "--api.dashboard=true",
        "--providers.docker.network=gt_public",
        "--entrypoints.web.address=:80",
        "--entrypoints.websecure.address=:443",
        "--certificatesresolvers.le.acme.httpchallenge=true",
        "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web",
        "--certificatesresolvers.le.acme.email=acme@gametactic.eu",
        "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json",
        "--log.level=DEBUG"
      ]

      # lb = loadbalancer. Example result: lb.eu.gametactic.eu.
      hostname = "lb.${var.swarm_fqdn}"

      # Mounts configuration
      mounts {
        # Hook Traefik into manager node docker socket.
        target = "/var/run/docker.sock"
        source = "/var/run/docker.sock"
        #read_only = true
        type = "bind"
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
    networks = [ docker_network.gt_public.id ]

    # Placement only on Master
    placement {
      constraints = [
        "node.role == manager"
      ]
    }
  }

  # Direct all HTTP/HTTPS to this service.
  endpoint_spec {
    ports {
      name = "http"
      protocol = "tcp"
      target_port = "80"
      published_port = "80"
      publish_mode = "ingress"
    }
    ports {
      name = "https"
      protocol = "tcp"
      target_port = "443"
      published_port = "443"
      publish_mode = "ingress"
    }
  }
}
