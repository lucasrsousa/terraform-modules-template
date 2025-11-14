# ========================
# Origin Access Control Core
# ========================

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

