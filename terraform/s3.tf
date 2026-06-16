#for creating a random string to append to the bucket name to ensure uniqueness
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}
# Create an S3 bucket for log archiving with versioning enabled
resource "aws_s3_bucket" "logs_archive" {

  bucket = "sre-log-archive-${random_string.bucket_suffix.result}"

}
# Enable versioning on the S3 bucket to preserve, retrieve, and restore every version of every object stored in the bucket
resource "aws_s3_bucket_versioning" "logs_versioning" {

  bucket = aws_s3_bucket.logs_archive.id

  versioning_configuration {

    status = "Enabled"

  }

}
#output the name of the S3 bucket created for log archiving
output "logs_bucket_name" {

  value = aws_s3_bucket.logs_archive.bucket

}