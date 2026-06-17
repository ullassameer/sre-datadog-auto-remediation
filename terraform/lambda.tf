resource "aws_iam_role" "lambda_role" {

  name = "sre-lambda-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {

          Service = "lambda.amazonaws.com"

        }

      }

    ]

  })

}



resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}



resource "aws_iam_role_policy_attachment" "lambda_ssm" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"

}



resource "aws_lambda_function" "diagnostics" {

  filename = "${path.module}/lambda/lambda.zip"

  function_name = "sre-diagnostics"

  role = aws_iam_role.lambda_role.arn

  handler = "lambda.lambda_handler"

  runtime = "python3.12"

  timeout = 60

  source_code_hash = filebase64sha256(
    "${path.module}/lambda/lambda.zip"
  )

  environment {

    variables = {

      INSTANCE_ID = aws_instance.ec2.id

      BUCKET = aws_s3_bucket.logs_archive.bucket

    }

  }

}