# Swarm Master
resource "hcloud_server" "swarm_manager" {
  count       = 1
  image       = data.hcloud_image.main.name
  server_type = var.hcloud_manager
  location    = var.hcloud_location
  ssh_keys    = ["${var.hcloud_user_sshkey_name}"]
  name        = "manager.${var.gt_cluster}.${var.gt_domain}"
  keep_disk   = true

  connection {
    host = self.ipv4_address
    type = "ssh"
    user = "root"
  }

  # Will install docker and initialize host as Swarm master
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -yqq",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io",
      "systemctl enable docker",
      "systemctl start docker",
      "docker swarm init --advertise-addr 10.0.1.10"
    ]
  }
}

# Add Master into subnet with static IP of 10.0.1.10
resource "hcloud_server_network" "swarm_manager_network" {
  count = length(hcloud_server.swarm_manager)
  server_id = hcloud_server.swarm_manager[count.index].id
  network_id = hcloud_network.swarm_network.id
  ip = "10.0.1.10"
}

# Update ReverseDNS according to the hostname
resource "hcloud_rdns" "rdns_manager" {
  count = length(hcloud_server.swarm_manager)
  server_id = hcloud_server.swarm_manager[count.index].id
  ip_address = hcloud_server.swarm_manager[count.index].ipv4_address
  dns_ptr = hcloud_server.swarm_manager[count.index].name
}

# Get IPv4
output "manager_ipv4" {
  value = "${hcloud_server.swarm_manager.*.ipv4_address}"
}
