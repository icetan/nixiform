variable "name" {}
variable "ssh_key" {}
variable "sg" {}

resource "aws_key_pair" "nixiform" {
  key_name   = "nixiform-key"
  public_key = "${var.ssh_key}"
}

resource "aws_instance" "nixos" {
  ami = "ami-0022b8ea9efde5de4" #nixos
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.nixiform.key_name}"
  security_groups = ["${var.sg}"]

  tags {
    Name = "nixiform_${var.name}"
  }
}

output "nixiform" {
  value = {
    name = "${var.name}"
    ip = "${aws_instance.nixos.public_ip}"
    ssh_key = "${var.ssh_key}"
    provider = "aws"
  }
}
