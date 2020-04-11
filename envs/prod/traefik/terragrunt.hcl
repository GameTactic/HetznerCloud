terraform {
  source = "../../../modules//traefik"
}

dependency "infra" {
  config_path = "../infra"
}

inputs = {
  swarm_manager = dependency.infra.outputs.manager_ipv4 
}
