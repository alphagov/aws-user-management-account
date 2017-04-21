resource "aws_iam_role" "lambda-manage-users" {
    name               = "lambda"
    description        = "Allow Lambda to assume any role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Sid": "AllowLambdaToAssumeRoles"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-attach-create-users" {
    role       = "${aws_iam_role.lambda-manage-users.name}"
    policy_arn = "${aws_iam_policy.create-users.arn}"
}
