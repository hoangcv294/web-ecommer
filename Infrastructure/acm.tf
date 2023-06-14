#######################-Create ACM-#######################
resource "aws_acm_certificate" "ecommerce_cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.domain_name} Certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################-Add record CNAME to Route53-#######################
resource "aws_route53_record" "cert_validation_record" {
  zone_id = data.aws_route53_zone.hostedzone.zone_id
  name    = tolist([aws_acm_certificate.ecommerce_cert.domain_validation_options])[0].resource_record_name
  type    = tolist([aws_acm_certificate.ecommerce_cert.domain_validation_options])[0].resource_record_type
  records = [tolist([aws_acm_certificate.ecommerce_cert.domain_validation_options])[0].resource_record_value]
  ttl     = 60
}

#######################-validation-#######################-
resource "aws_acm_certificate_validation" "acm_validation" {
  provider                = aws.us-east-1
  certificate_arn         = [aws_acm_certificate.ecommerce_cert.arn]
  validation_record_fqdns = [aws_route53_record.cert_validation_record.fqdn]
}