output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}
# outputs.tf

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "public_subnets" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}
output "alb_certificate_arn" {
  description = "ARN of the ACM certificate for the ALB"
  value       = length(aws_acm_certificate.alb_cert) > 0 ? aws_acm_certificate.alb_cert[0].arn : null
}

output "alb_certificate_validation_status" {
  description = "Validation status of the ACM certificate"
  value       = length(aws_acm_certificate_validation.alb_cert_validation_complete) > 0 ? aws_acm_certificate_validation.alb_cert_validation_complete[0].certificate_arn : null
}

