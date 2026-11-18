output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "nginx_domain" {
  value = aws_route53_record.nginx.fqdn
}

output "envoy_domain" {
  value = aws_route53_record.envoy.fqdn
}