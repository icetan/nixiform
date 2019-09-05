variable "name" {}
variable "authorized_keys" {
  type = "list"
}
variable "sg" {}

resource "aws_key_pair" "terranix" {
  key_name   = "terranix-key"
  public_key = "${var.authorized_keys[0]}"
}

resource "aws_instance" "nixos" {
  ami = "ami-0022b8ea9efde5de4" #nixos
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.terranix.key_name}"
  security_groups = ["${var.sg}"]

  tags {
    Name = "terranix-${var.name}"
  }
}

output "provider" {
  value = "aws"
}

output "name" {
  value = "${var.name}"
}

output "ip" {
  value = "${aws_instance.nixos.public_ip}"
}

output "authorized_keys" {
  value = ["${var.authorized_keys[0]}"]
}
