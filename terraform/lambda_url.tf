resource "aws_lambda_function_url" "diagnostics" {

  function_name =aws_lambda_function.diagnostics.function_name

  authorization_type = "NONE"

}