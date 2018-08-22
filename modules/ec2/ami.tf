variable "ami_id"                  { }
variable "instance_type"           { }
variable "key_name"                { }
variable "security_group"          { }
variable "user"                    { }
variable "private_key"             { }
variable "instance_name"           { }
variable "env"                     { }
variable "enable_eip"              { }
variable "elastic_ip"              { }


resource "aws_instance" "epc-api-explorer" {
  ami                 = "${var.ami_id}"
  instance_type       = "${var.instance_type}"
  key_name            = "${var.key_name}"
  security_groups     = ["${var.security_group}"]
  tags {
    Name              = "${var.instance_name}-${var.env}"
  }

  "connection" {
    user              = "${var.user}"
    private_key       = "${file("${var.private_key}")}"
    timeout           = "30s"
    agent             = "false"
  }

  provisioner "file" {
    source            = "./include"
    destination       = "/tmp"
  }

  provisioner "remote-exec" {
    inline            = [
      "echo \"******* change scripts to executable ***\"",
      "sudo chmod +x /tmp/include/*",

      "echo \"******* Run provisioner script ***\"",
      "bash /tmp/include/scripts/provision-driver"
    ]
  }
}

/* Including feature toggle to enable/disable elastic ip association */
resource "aws_eip_association" "eip_assoc" {
  count               = "${ var.enable_eip == "true" ? 1 : 0 }"
  instance_id         = "${aws_instance.epc-api-explorer.id}"
  public_ip           = "${var.elastic_ip}"
}

output "public_dns" {
  value               = "${aws_instance.epc-api-explorer.public_dns}"
}
