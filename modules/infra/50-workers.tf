# Swarm Workers

# Create Server
resource "hcloud_server" "swarm_worker" {
  count       = var.hcloud_worker_count
  image       = data.hcloud_image.main.name
  server_type = var.hcloud_worker
  location    = var.hcloud_location
  ssh_keys    = ["${var.hcloud_user_sshkey_name}"]
  name        = "node-${count.index + 1}.${var.gt_cluster}.${var.gt_domain}"
  keep_disk   = true
  depends_on = [ hcloud_server.swarm_manager ]

  # We use SSH to manipulate the server.
  connection {
    host = self.ipv4_address
    type = "ssh"
    user = "root"
  }

  # Install Docker and Join Swarm Cluster
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -yqq",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io",
      "systemctl enable docker",
      "systemctl start docker"
    ]
  }

  # Move workload to other nodes.
  provisioner "remote-exec" {
    # Use Manager for this Provisioner
    connection {
      type = "ssh"
      user = "root"
      host = hcloud_server.swarm_manager.0.ipv4_address
    }

    when = destroy
    inline = [ "docker node update --availability drain ${self.name}" ]
    on_failure = continue
  } 

  # Remove node from cluster.
  provisioner "remote-exec" {
    when = destroy
    inline = [ "docker swarm leave" ]
    on_failure = continue
  }
  
  # Destroy Node.
  provisioner "remote-exec" {
    # Use Manager for this Provisioner
    connection {
      type = "ssh"
      user = "root"
      host = hcloud_server.swarm_manager.0.ipv4_address
    }

    when = destroy
    inline = [ "docker node rm --force ${self.name}" ]
    on_failure = continue
  }
}

# Load Swarm Tokens
data "external" "swarm_tokens" {
  program = [ "./scripts/swarm_tokens.sh" ]
  query = {
    # The Manager Node IP should always be same, if accessed via private network.\
    host = "${hcloud_server.swarm_manager.0.ipv4_address}"
  }
  depends_on = [ hcloud_server.swarm_manager ]
}

# Private Network (Cluster)
resource "hcloud_server_network" "swarm_worker_network" {
  count = length(hcloud_server.swarm_worker)
  server_id = hcloud_server.swarm_worker[count.index].id
  network_id = hcloud_network.swarm_network.id
  ip = "10.0.1.1${count.index + 1}"

  # Network Connected: SSH Settings for cluster join command
  connection {
    host = hcloud_server.swarm_worker[count.index].ipv4_address
    type = "ssh"
    user = "root"
  }

  # Network Connected: Add into Cluster
  provisioner "remote-exec" {
    inline = [ "docker swarm join --token ${data.external.swarm_tokens.result.worker} 10.0.1.10:2377" ]
  }
}

# ReverseDNS Entries (Worker)
resource "hcloud_rdns" "rdns_worker" {
  count = length(hcloud_server.swarm_worker)
  server_id = hcloud_server.swarm_worker[count.index].id
  ip_address = hcloud_server.swarm_worker[count.index].ipv4_address
  dns_ptr = hcloud_server.swarm_worker[count.index].name
}
