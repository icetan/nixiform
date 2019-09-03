variable "name" {}
variable "authorized_keys" {
  type = "list"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Some SSH key"
  public_key = "${var.authorized_keys[0]}"
}

resource "digitalocean_droplet" "ubuntu" {
  image  = "ubuntu-18-04-x64"
  name   = "terranix-${var.name}"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}

output "provider" {
  value = "digitalocean"
}

output "name" {
  value = "${var.name}"
}

output "ip" {
  value = "${digitalocean_droplet.ubuntu.ipv4_address}"
}

output "authorized_keys" {
  value = ["${var.authorized_keys[0]}"]
}
