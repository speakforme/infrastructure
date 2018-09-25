resource "aws_s3_bucket" "infrastructure" {
  bucket = "speakforme-infrastructure"

  acl = "private"

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
            "Resource": "arn:aws:s3:::speakforme-infrastructure/emails/*",
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
