provider "vultr" {
  rate_limit = 700
}

module "node-1" {
  source  = "./vultr_nixos"
  name    = "node-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
