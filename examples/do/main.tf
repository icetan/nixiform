provider "digitalocean" {
}

variable "name" {
  default = "server"
}

variable "node_count" {
  default = 1
}

locals {
  ssh_key = file("${path.module}/../ssh_key.pub")
}

resource "digitalocean_ssh_key" "default" {
  name       = "TerraNix SSH key"
  public_key = local.ssh_key
}

resource "digitalocean_droplet" "ubuntu" {
  count = var.node_count
  image  = "ubuntu-18-04-x64"
  name   = format("%s%02d", var.name, count.index + 1)
  region = "ams3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

output "terranix" {
  value = [for droplet in digitalocean_droplet.ubuntu : {
    name = droplet.name
    ip = droplet.ipv4_address
    ssh_key = local.ssh_key
    provider = "digitalocean"
  }]
}
