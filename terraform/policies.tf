data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_any_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "assume_any_role" {
  name        = "assume_any_role"
  description = "Allows the user to call sts:AssumeRole on anything"
  policy      = data.aws_iam_policy_document.assume_any_role.json
}

data "aws_iam_policy_document" "self_manage_iam_user" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetUser",
      "iam:ListUserPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:ListGroupsForUser",
      "iam:*LoginProfile",
      "iam:*AccessKey*",
      "iam:*SSHPublicKey*",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:ListAccount*",
      "iam:GetAccountSummary",
      "iam:GetAccountPasswordPolicy",
      "iam:ListUsers",
      "iam:ListGroups",
      "iam:ListGroupPolicies",
      "iam:ListAttachedGroupPolicies",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowUsersToCreateAndDeleteMFADevices"
    effect = "Allow"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}*",
    ]
  }

  statement {
    sid    = "AllowUsersToEnableAndResyncTheirOwnVirtualMFADevice"
    effect = "Allow"

    actions = [
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:ResyncMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]
  }

  statement {
    sid    = "RequireMFAWhenUsersDeactivateTheirOwnVirtualMFADevice"
    effect = "Allow"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true",
      ]
    }
  }

  statement {
    sid    = "AllowUsersToListMFADevicesandUsersForConsole"
    effect = "Allow"

    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "self_manage_iam_user" {
  name        = "self_manage_iam_user"
  description = "Allows the user to manage their own credentials and list all users"
  policy      = data.aws_iam_policy_document.self_manage_iam_user.json
}
