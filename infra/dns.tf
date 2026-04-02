# ACM Certificate (optional)
resource "aws_acm_certificate" "alb_cert" {
  count             = var.domain_name != "" && var.route53_zone_id != "" ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-alb-cert"
  }
}

# Route53 validation records (optional)
resource "aws_route53_record" "alb_cert_validation" {
  for_each = var.domain_name != "" && var.route53_zone_id != "" ? {
    for dvo in aws_acm_certificate.alb_cert[0].domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# ACM validation completion (optional)
resource "aws_acm_certificate_validation" "alb_cert_validation_complete" {
  count = var.domain_name != "" && var.route53_zone_id != "" ? 1 : 0

  certificate_arn = aws_acm_certificate.alb_cert[0].arn
  validation_record_fqdns = [
    for record in aws_route53_record.alb_cert_validation : record.fqdn
  ]
}