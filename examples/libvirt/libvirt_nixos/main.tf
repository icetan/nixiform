variable "name" {}
variable "authorized_keys" {
  type = "list"
}

resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image-${var.name}"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
}

resource "libvirt_volume" "disk_ubuntu_resized" {
  name           = "disk-${var.name}"
  base_volume_id = "${libvirt_volume.os_image_ubuntu.id}"
  pool           = "default"
  size           = 5361393664
}

# Use CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "cloudinit_ubuntu_resized" {
  name = "cloudinit_image-${var.name}"
  pool = "default"

  user_data = <<EOF
#cloud-config
disable_root: 0
ssh_pwauth: 1
users:
  - name: root
    ssh-authorized-keys: [ ${join(",", var.authorized_keys)} ]
growpart:
  mode: auto
  devices: ['/']
EOF
}

resource "libvirt_domain" "domain_ubuntu_resized" {
  name   = "${var.name}"
  memory = "512"
  vcpu   = 1

  cloudinit = "${libvirt_cloudinit_disk.cloudinit_ubuntu_resized.id}"

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
    volume_id = "${libvirt_volume.disk_ubuntu_resized.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "provider" {
  value = "libvirt"
}

output "name" {
  value = "${var.name}"
}

output "ip" {
  value = "${libvirt_domain.domain_ubuntu_resized.network_interface.0.addresses.0}"
}

output "authorized_keys" {
  value = ["${var.authorized_keys}"]
}
