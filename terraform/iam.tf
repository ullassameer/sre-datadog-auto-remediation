# This Terraform configuration defines the necessary AWS IAM resources for an EC2 instance to interact with S3 and SSM services. It creates an IAM role, attaches policies for S3 access and SSM read permissions, and sets up an instance profile for EC2 instances to assume the role.
resource "aws_iam_role" "ec2_role" {
  name = "sre-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
# Define a custom IAM policy for S3 access to allow the EC2 instance to upload logs to the S3 bucket and list the bucket contents.
resource "aws_iam_policy" "logs_archive_upload" {

  name = "logs-archive-upload"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "s3:PutObject",
           "s3:GetObject",
          "s3:ListBucket"

        ]

        Resource = [

          aws_s3_bucket.logs_archive.arn,

          "${aws_s3_bucket.logs_archive.arn}/*"

        ]

      }

    ]

  })

}




# Define a custom IAM policy for SSM read permissions to allow the EC2 instance to read parameters from AWS Systems Manager Parameter Store.
resource "aws_iam_policy" "ssm_read" {

  name = "datadog-ssm-read"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "ssm:GetParameter"

        ]

        Resource = "*"

      }

    ]

  })

}
# Attach the AmazonSSMManagedInstanceCore policy to the IAM role to allow the EC2 instance to communicate with AWS Systems Manager for management and automation tasks.
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# Attach the custom S3 access policy to the IAM role to allow the EC2 instance to upload logs to the S3 bucket and list the bucket contents.
resource "aws_iam_role_policy_attachment" "attach_logs_upload" {

  role = aws_iam_role.ec2_role.name

  policy_arn = aws_iam_policy.logs_archive_upload.arn

}
# Attach the custom SSM read policy to the IAM role to allow the EC2 instance to read parameters from AWS Systems Manager Parameter Store.
resource "aws_iam_role_policy_attachment" "custom_ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_read.arn
}
# Create an IAM instance profile and associate it with the IAM role to allow EC2 instances to assume the role and gain the necessary permissions for S3 access and SSM read operations.
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "sre-profile"
  role = aws_iam_role.ec2_role.name
}