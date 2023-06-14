#######################-Import R53-#######################
resource "aws_route53_zone" "hoangdevops" {
  name = "${var.domain_name}.com"  # Replace with your domain name
}

#######################-Create Record Alias CloudFront-#######################
resource "aws_route53_record" "route53_record_alias_frontend" {
  zone_id = data.aws_route53_zone.hostedzone.zone_id
  name    = "${var.domain_name}"
  type    = "A"
  alias {
    name                   = [aws_lb.ecommerce_lb.dns_name]
    zone_id                = [aws_lb.ecommerce_lb.hosted_zone_id]
    evaluate_target_health = false
  }
}