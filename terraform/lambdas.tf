resource "aws_lambda_function" "create-user" {
    description      = "Create a user with a login profile and cross-account access"
    filename         = "create_user.py"
    function_name    = "create_user"
    role             = "${aws_iam_role.lambda-manage-users.arn}"
    handler          = "create_user.create_user"
    source_code_hash = "${base64sha256(file("create_user.py"))}"
    runtime          = "python3.6"
}
