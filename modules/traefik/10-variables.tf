# Configuration Variables

variable "swarm_manager" { 
  description = "IP of Docker Swarm manager."
}

variable "swarm_fqdn" {
  description = "FQDN of swarm cluster. Should be given from infra module automatically."
}

variable "acme_email" {
  description = "Used for LetsEncrypt certifactes in Traefik."
}
