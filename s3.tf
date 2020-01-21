// This bucket is in ap-south-1
resource "aws_s3_bucket" "infrastructure" {
  bucket   = "${var.infrastructure-bucket}"
  provider = "aws.mumbai"

  acl = "private"

  tags = {
    Name        = "${var.infrastructure-bucket}"
    environment = "${var.campaign-env}"
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
  bucket = "${var.email-bucket}"

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

  tags = {
    Name        = "${var.email-bucket}"
    environment = "${var.campaign-env}"
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

resource "aws_s3_bucket_policy" "email-bucket" {
  bucket = "${aws_s3_bucket.emails.id}"
  policy = "${data.aws_iam_policy_document.email-bucket.json}"
}
