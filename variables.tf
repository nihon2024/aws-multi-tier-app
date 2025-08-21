# AWS region
variable "region" {
  type    = string
  description = "AWS region to deploy resources"
  default = "us-east-1"
}

# Project name
variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "multi-tier-app"
}

# RDS master username
variable "db_username" {
  type        = string
  description = "RDS master username"
  default     = "admin"
}

# RDS master password (sensitive)
variable "db_password" {
  type        = string
  description = "RDS master password"
  sensitive   = true
}

# RDS allocated storage in GB
variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage for RDS instance in GB"
  default     = 20
}

# RDS instance class
variable "db_instance_class" {
  type        = string
  description = "RDS instance type"
  default     = "db.t3.micro"
}

# Database engine
variable "db_engine" {
  type        = string
  description = "Database engine for RDS instance"
  default     = "mysql"
}

# Database engine version
variable "db_engine_version" {
  type        = string
  description = "Database engine version"
  default     = "8.0"
}
# Domain name for your application
variable "domain_name" {
  description = "The domain name to use for the ALB ACM certificate"
  type        = string
}

# Route53 hosted zone ID where the DNS records will be created
variable "route53_zone_id" {
  description = "The Route53 Hosted Zone ID for domain validation"
  type        = string
}
