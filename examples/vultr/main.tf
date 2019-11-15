provider "vultr" {
  rate_limit = 700
}

variable "name" {
  default = "server"
}

variable "node_count" {
  default = 1
}

locals {
  ssh_key = file("${path.module}/../ssh_key.pub")
}

resource "vultr_ssh_key" "default" {
  name     = "Nixiform SSH key"
  ssh_key  = local.ssh_key
}

resource "vultr_server" "ubuntu" {
  count = var.node_count
  label = format("server_%02d", count.index + 1)
  ssh_key_ids = vultr_ssh_key.default[*].id

  plan_id = "201" # 1024 MB RAM,25 GB SSD,1.00 TB BW (5.00 USD/month)
  region_id = "9" # Frankfurt
  #iso_id = "204500" # Ubuntu 16.04
  os_id = "215" # Ubuntu 16.04 x64
}

output "nixiform" {
  value = [for server in vultr_server.ubuntu : {
    name = server.label
    ip = server.main_ip
    ssh_key = local.ssh_key
    provider = "vultr"
  }]
}
