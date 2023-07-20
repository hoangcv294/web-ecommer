#######################-Get Data ACM-#######################
data "aws_acm_certificate" "ecommerce_cert" {
  # provider = "ap-southeast-1"
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

