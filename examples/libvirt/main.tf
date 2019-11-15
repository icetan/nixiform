provider "libvirt" {
  uri = "qemu:///system"
}

module "server" {
  source     = "./libvirt_nixos"
  name       = "server"
  node_count = 2
  ssh_key    = file("${path.module}/../ssh_key.pub")
}

output "nixiform" {
  value = module.server.nixiform
}

