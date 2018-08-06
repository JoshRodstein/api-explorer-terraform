
resource "aws_s3_bucket_object" "file_0" {
  bucket = "${aws_s3_bucket.static_site.bucket}"
  key = "/README.md"
  source = "./api-specs/README.md"
  content_type = "${lookup(var.mime_types, "md")}"
  etag = "${md5(file("./api-specs/README.md"))}"
}

resource "aws_s3_bucket_object" "file_1" {
  bucket = "${aws_s3_bucket.static_site.bucket}"
  key = "/api-ex-1.yaml"
  source = "./api-specs/api-ex-1.yaml"
  content_type = "${lookup(var.mime_types, "yaml")}"
  etag = "${md5(file("./api-specs/api-ex-1.yaml"))}"
}
