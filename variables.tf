variable "region" {
  default = "us-east-2"
}

provider "aws" {
    profile = "default"
    region = "${var.region}"
}
