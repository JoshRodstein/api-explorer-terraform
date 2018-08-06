provider "aws" {
  access_key = "AKIAI7LVW6H4SHQGLYNA"
  secret_key = "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"
  region     = "us-east-2"
}

variable "mime_types" {
  default = {
    yaml = "application/yaml"
    json = "application/json"
  }
}

variable "bucket" {
  default = "epc-api-specs"
}

data "template_file" "s3_public_policy" {
  template = "${file("policies/s3-public.json")}"
  vars {
    bucket_name = "${var.bucket}"
  }
}

resource "aws_s3_bucket" "epc-api-specs" {
  bucket = "${var.bucket}"
  acl = ""
  policy = "${data.template_file.s3_public_policy.rendered}"
}
