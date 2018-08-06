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
  acl = "public-read"
  policy = "${data.template_file.s3_public_policy.rendered}"


}
