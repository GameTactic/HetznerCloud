terraform {
  source = "../../../modules//room"
}

dependency "infra" {
  config_path = "../infra"
}

dependency "traefik" {
  config_path = "../traefik"
}

inputs = {
  swarm_manager = dependency.infra.outputs.manager_ipv4
  swarm_fqdn    = dependency.infra.outputs.fqdn
  lb_network    = dependency.traefik.outputs.lb_network
}
