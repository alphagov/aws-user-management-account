data "archive_file" "create_user_code" {
  type = "zip"
  source_dir = "${path.module}/lambda-functions/create-user/"
  output_path = "${path.module}/.terraform/archive_files/lambda-create-user.zip"
}

resource "aws_lambda_function" "create_user" {
    description      = "Create a user with a login profile and cross-account access"
    filename         = "${data.archive_file.create_user_code.output_path}"
    function_name    = "create_user"
    role             = "${aws_iam_role.lambda_manage_users.arn}"
    handler          = "create_user.create_user"
    source_code_hash = "${data.archive_file.create_user_code.output_base64sha256}"
    runtime          = "python3.6"
}
