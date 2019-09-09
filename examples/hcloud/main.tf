provider "hcloud" {
}

locals {
  ssh_key = file("${path.module}/../ssh_key.pub")
}

resource "hcloud_ssh_key" "default" {
  name       = "TerraNix SSH key"
  public_key = local.ssh_key
}

resource "hcloud_server" "ubuntu" {
  name = "server"
  server_type = "cx11"
  image = "ubuntu-18.04"
  ssh_keys = [hcloud_ssh_key.default.id]
}

output "terranix" {
  value = {
    name = hcloud_server.ubuntu.name
    ip = hcloud_server.ubuntu.ipv4_address
    ssh_key = local.ssh_key
    provider = "hcloud"
  }
}
