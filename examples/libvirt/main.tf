provider "libvirt" {
  uri = "qemu:///system"
}

module "nixos-1" {
  source  = "./libvirt_nixos"
  name    = "nixos-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}

module "nixos-2" {
  source  = "./libvirt_nixos"
  name    = "nixos-2"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
