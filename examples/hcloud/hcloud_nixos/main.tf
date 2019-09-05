variable "name" {}
variable "authorized_keys" {
  type = "list"
}

resource "hcloud_ssh_key" "default" {
  name       = "Some SSH key"
  public_key = "${var.authorized_keys[0]}"
}

resource "hcloud_server" "ubuntu" {
  name = "terranix-${var.name}"
  server_type = "cx11"
  image = "ubuntu-18.04"
  ssh_keys = ["${hcloud_ssh_key.default.id}"]
}

output "provider" {
  value = "hcloud"
}

output "name" {
  value = "${var.name}"
}

output "ip" {
  value = "${hcloud_server.ubuntu.ipv4_address}"
}

output "authorized_keys" {
  value = ["${var.authorized_keys[0]}"]
}
