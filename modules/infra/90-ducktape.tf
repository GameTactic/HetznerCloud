# This fixes issues with SSH not working to docker machines.
# Ref: https://github.com/terraform-providers/terraform-provider-docker/issues/170

## Start of DuckTape ##
resource "null_resource" "ssh_commands" {
  connection {
    host = hcloud_server.swarm_manager.0.ipv4_address
    type = "ssh"
  }

  provisioner "remote-exec" {
    inline = [ "whoami" ]
  }
}

resource "null_resource" "ssh_remember" {
  # Re-Add local entry
  provisioner "local-exec" {
    command = "ssh-keyscan -H ${hcloud_server.swarm_manager.0.ipv4_address} >> ~/.ssh/known_hosts"
  }

  depends_on = [ null_resource.ssh_commands ]
}

## End of DuckTape ##