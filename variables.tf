# Configuration Variables
variable "hcloud_token" {
  description = "This token is from Hetzner management panel."
  default = ""
}

variable "hcloud_user_sshkey_name" {
  default = ""
}

variable "hcloud_location" {
  default = "hel1"
}

variable "hcloud_worker" {
  default = "cx11"
}

variable "hcloud_manager" {
  default = "cx11"
}

variable "hcloud_worker_count" {
  default = 3
}

variable "gt_domain" {
  default = "gametactic.eu"
}

variable "gt_cluster" {
  default = "eu"
}

