# S3 Bucket with encryption
resource "aws_s3_bucket" "web_s3_bucket" {
  bucket = "${var.application_name}-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "web_s3_bucket" {
  bucket = aws_s3_bucket.web_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#identifiers = [aws_cloudfront_origin_access_identity.app_origin_access_identity.iam_arn, "*"]
data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "MustBeEncryptedInTransit"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.web_s3_bucket.arn}/*", aws_s3_bucket.web_s3_bucket.arn]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }
  }
}
