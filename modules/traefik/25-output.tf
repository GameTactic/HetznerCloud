# Output for Loadbalancer Network
output "lb_network" {
  value = "${docker_network.gt_public.id}"
}
