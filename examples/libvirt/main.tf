provider "libvirt" {
  uri = "qemu:///system"
}

module "node-1" {
  source  = "./libvirt_nixos"
  name    = "node-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}

module "node-2" {
  source  = "./libvirt_nixos"
  name    = "node-2"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
