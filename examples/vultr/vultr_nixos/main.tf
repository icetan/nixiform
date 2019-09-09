variable "name" {}
variable "authorized_keys" {
  type = "list"
}

resource "vultr_ssh_key" "default" {
  name       = "Some SSH key"
  ssh_key = "${var.authorized_keys[0]}"
}

resource "vultr_server" "nixos" {
  label = "${var.name}"
  plan_id = "201" # 1024 MB RAM,25 GB SSD,1.00 TB BW (5.00 USD/month)
  region_id = "9" # Frankfurt
  #iso_id = "204500" # Ubuntu 16.04
  os_id = "215" # Ubuntu 16.04 x64
  ssh_key_ids = ["${vultr_ssh_key.default.id}"]
}

output "provider" {
  value = "vultr"
}

output "name" {
  value = "${var.name}"
}

output "ip" {
  value = "${vultr_server.nixos.main_ip}"
}

output "authorized_keys" {
  value = ["${var.authorized_keys[0]}"]
}
