variable "hcloud_token" {}

provider "hcloud" {
  token = "${var.hcloud_token}"
}

module "node-1" {
  source  = "./hcloud_nixos"
  name    = "node-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
