# Output for Redis Network
output "redis_network" {
  value = "${docker_network.gt_redis.id}"
}
