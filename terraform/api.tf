resource "aws_api_gateway_rest_api" "users-api" {
    name        = "users-api"
    description = "Manage users in the base account"
}

resource "aws_api_gateway_resource" "users" {
    rest_api_id = "${aws_api_gateway_rest_api.users-api.id}"
    parent_id   = "${aws_api_gateway_rest_api.users-api.root_resource_id}"
    path_part   = "users"
}

resource "aws_api_gateway_method" "create-user-method" {
    rest_api_id      = "${aws_api_gateway_rest_api.users-api.id}"
    resource_id      = "${aws_api_gateway_resource.users.id}"
    http_method      = "POST"
    authorization    = "AWS_IAM"
    api_key_required = true
}

resource "aws_api_gateway_integration" "users-api-lambda-integration" {
    rest_api_id             = "${aws_api_gateway_rest_api.users-api.id}"
    resource_id             = "${aws_api_gateway_rest_api.users-api.root_resource_id}"
    http_method             = "${aws_api_gateway_method.create-user-method.http_method}"
    integration_http_method = "POST"
    type                    = "AWS"
    # The date here is the Lambda API version
    uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.create-user.arn}/invocations"
}

resource "aws_api_gateway_stage" "production" {
    stage_name    = "production"
    rest_api_id   = "${aws_api_gateway_rest_api.users-api.id}"
    deployment_id = "${aws_api_gateway_deployment.production.id}"
}

resource "aws_api_gateway_deployment" "production" {
    depends_on  = ["aws_api_gateway_integration.users-api-lambda-integration"]
    rest_api_id = "${aws_api_gateway_rest_api.users-api.id}"
    stage_name  = "production"
}
