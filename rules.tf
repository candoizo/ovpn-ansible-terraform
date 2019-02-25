variable "vpn_ports" {
  default = ["1194", "3000"]
}

resource "aws_security_group" "vpn" {
  name        = "vpn"
  description = "Allow vpn access on the instance."
}

resource "aws_security_group_rule" "ingress" {
  count = "${length(var.vpn_ports)}"

  security_group_id = "${aws_security_group.vpn.id}"
  type              = "ingress"
  from_port         = "${element(var.vpn_ports, count.index)}"
  to_port           = "${element(var.vpn_ports, count.index)}"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

variable "tcp_ports" {
  default = ["22", "80", "443"]
}

resource "aws_security_group" "tcp" {
  description = "Allow inbound ssh on the instance."
}

resource "aws_security_group_rule" "tcp_ingress" {
  count = "${length(var.tcp_ports)}"

  security_group_id = "${aws_security_group.tcp.id}"
  type              = "ingress"
  from_port         = "${element(var.tcp_ports, count.index)}"
  to_port           = "${element(var.tcp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tcp_egress" {
  count = "${length(var.tcp_ports)}"

  security_group_id = "${aws_security_group.tcp.id}"
  type              = "egress"
  from_port         = "${element(var.tcp_ports, count.index)}"
  to_port           = "${element(var.tcp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
