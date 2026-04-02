# s3.tf

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_name}-bucket"
  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
}
