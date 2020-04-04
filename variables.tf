# Configuration Variables
variable "hcloud_token" {
  description = "This token is from Hetzner management panel."
  default = ""
}

variable "hcloud_user_sshkey_name" {
  description = "SSH key to add all created VMs. Must be present in advance!"
  default = ""
}

variable "hcloud_location" {
  description = "Datacenter. Available: hel1,fsn1,nbg1"
  default = "hel1"
}

variable "hcloud_worker" {
  description = "Server package. Affects pricing."
  default = "cx11"
}

variable "hcloud_manager" {
  description = "Server package. Affects pricing."
  default = "cx11"
}

variable "hcloud_worker_count" {
  description = "Amount of nodes in swarm cluster."
  default = 3
}

variable "gt_domain" {
  description = "Top level domain for the service. Example: service.gt_cluster.gt_domain."
  default = "gametactic.eu"
}

variable "gt_cluster" {
  description = "Cluster subdomain. Example: service.gt_cluster.gt_domain."
  default = "eu"
}

