// This bucket is in ap-south-1
resource "aws_s3_bucket" "infrastructure" {
  bucket   = "speakforme-infrastructure"
  provider = "aws.mumbai"

  acl = "private"

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

// This bucket is in eu-west-1
resource "aws_s3_bucket" "emails" {
  bucket = "speakforme-emails"

  acl = "private"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "world"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSESPuts",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::speakforme-emails/*",
            "Condition": {
                "StringEquals": {
                    "aws:Referer": "531324969672"
                }
            }
        }
    ]
}
EOF

  tags {
    Name        = "speakforme-emails"
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
