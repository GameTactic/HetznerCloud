# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Image to be used in all VMs
data "hcloud_image" "main" {
  name = "ubuntu-18.04"
}
