# Configuration Variables

variable "swarm_manager" { 
  description = "IP of Docker Swarm manager."
}

variable "swarm_fqdn" {
  description = "FQDN of swarm cluster. Should be given from infra module automatically."
}

#variable "redis_masters" {
#  description = "Amount of Redis masters created."
#}

#variable "redis_slaves" {
#  description = "Amount of Redis slaves created."
#}
