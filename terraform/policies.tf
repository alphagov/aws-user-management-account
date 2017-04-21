data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "assume-any-role" {
    name = "assume-any-role"
    description = "Allows the user to call sts:AssumeRole on anything"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "self-manage-iam-user" {
    name = "self-manage-iam-user"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*LoginProfile",
                "iam:*AccessKey*",
                "iam:*SSHPublicKey*"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListAccount*",
                "iam:GetAccountSummary",
                "iam:GetAccountPasswordPolicy",
                "iam:ListUsers"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:DeleteVirtualMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToDeactivateTheirOwnVirtualMFADevice",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ],
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": true
                }
            }
        },
        {
            "Sid": "AllowUsersToListMFADevicesandUsersForConsole",
            "Effect": "Allow",
            "Action": [
                "iam:ListMFADevices",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "create-users" {
    name        = "create-users"
    description = "Allow creating users"
    policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCreatingUsers"
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:AddUserToGroup",
                "iam:CreateLoginProfile"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
