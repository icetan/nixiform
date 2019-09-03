variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

module "do-1" {
  source  = "./do_nixos"
  name    = "do-1"
  authorized_keys = [ "${file("${path.module}/../ssh_key.pub")}" ]
}
