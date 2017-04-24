resource "aws_lambda_function" "create-user" {
    description      = "Create a user with a login profile and cross-account access"
    filename         = "create_user.py"
    function_name    = "create_user"
    role             = "${aws_iam_role.lambda-manage-users.arn}"
    handler          = "create_user.create_user"
    source_code_hash = "${base64sha256(file("create_user.py"))}"
    runtime          = "python3.6"
}

resource "aws_lambda_permission" "apigw_lambda" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.create-user.arn}"
    principal     = "apigateway.amazonaws.com"

    # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
    source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.users-api.id}/*/${aws_api_gateway_method.create-user-method.http_method}/users"
}
