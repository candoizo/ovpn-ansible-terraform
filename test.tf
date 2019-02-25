provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "laptop" {
  public_key = "${var.sshkey}"
}

resource "aws_instance" "osimage" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.laptop.key_name}"

  security_groups = [
    "${aws_security_group.tcp.name}",
    "${aws_security_group.vpn.name}",
  ]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.osimage.id}"
}

resource "local_file" "ansible_host" {
  content  = "[aws/vpn]\n${aws_eip.ip.public_ip} ansible_user=root"
  filename = "h"
}

resource "local_file" "ip" {
  content  = "${aws_eip.ip.public_ip}"
  filename = "ip.txt"
}

output "vpn_server" {
  value = "${aws_eip.ip.public_ip}"
}
