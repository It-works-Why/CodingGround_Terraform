# resource "aws_route53_zone" "primary" {
#   name = "your_domain.com"
# }

# resource "aws_route53_record" "validation" {
#   name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
#   type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
#   zone_id = "${aws_route53_zone.primary.zone_id}"
#   records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
#   ttl     = 60
# }