variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

module "node-1" {
  source  = "./do_nixos"
  name    = "node-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
