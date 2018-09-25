resource "aws_s3_bucket" "infrastructure" {
  bucket = "speakforme-infrastructure"
  acl    = "private"

  tags {
    Name        = "speakforme-infrastructure"
    environment = "production"
    terraform   = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
