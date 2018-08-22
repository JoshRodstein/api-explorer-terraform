provider "aws" {
  region          = "${var.region}"
}

/* Configs for backend passed via command line at "init" */
terraform {
  backend "s3" { }
}

module "ec2_security_group" {
  source          = "./modules/security_groups/"
  env             = "${var.env}"
}

module "aws_ami" {
  source          = "./modules/ec2"

 /* aws_instance Configs */
  ami_id          = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  instance_name   = "${var.instance_name}"
  user            = "${var.user}"
  private_key     = "${var.private_key}"
  key_name        = "${var.key_name}"

  /* Network/Security Configs */
  env             = "${var.env}"
  security_group  = "${module.ec2_security_group.id}"
  enable_eip      = "${var.enable_eip}"
  elastic_ip      = "${var.elastic_ip}"
}
