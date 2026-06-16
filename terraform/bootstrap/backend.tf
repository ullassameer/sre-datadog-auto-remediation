resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "sre-dd-state-${random_string.bucket_suffix.result}"

}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "lock" {
  name         = "terraform-lock-${random_string.bucket_suffix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}