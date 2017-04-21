data "aws_iam_policy_document" "lambda_assume_role" {
    statement {
        sid = "AllowLambdaToAssumeRoles"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "lambda.amazonaws.com"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
    }
}

resource "aws_iam_role" "lambda_manage_users" {
    name               = "lambda_manage_users"
    assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "lambda-attach-create-users" {
    role       = "${aws_iam_role.lambda_manage_users.name}"
    policy_arn = "${aws_iam_policy.create_users.arn}"
}
