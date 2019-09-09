variable "name" {}
variable "node_count" {}
variable "ssh_key" {}

resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_${var.name}"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
}

resource "libvirt_volume" "disk_ubuntu" {
  count          = var.node_count
  name           = format("disk_%02d", count.index + 1)
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = "default"
  size           = 5361393664
}

# Use CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "cloudinit_image"
  pool = "default"

  user_data = <<EOF
#cloud-config
disable_root: 0
ssh_pwauth: 1
users:
  - name: root
    ssh-authorized-keys: [ ${var.ssh_key} ]
growpart:
  mode: auto
  devices: ['/']
EOF
}

resource "libvirt_domain" "ubuntu" {
  count     = var.node_count
  name      = format("%s_%02d", var.name, count.index + 1)
  memory    = "512"
  vcpu      = 1
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  # IMPORTANT
  # Ubuntu can hang if an isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.disk_ubuntu[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "terranix" {
  value = [for domain in libvirt_domain.ubuntu : {
    name = domain.name
    ip = domain.network_interface.0.addresses.0
    ssh_key = var.ssh_key
    provider = "libvirt"
  }]
}
