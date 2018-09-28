resource "aws_iam_group" "cross-account-access" {
  name = "CrossAccountAccess"
}

resource "aws_iam_group_policy_attachment" "cross-account-attach-self-manage" {
  group      = "${aws_iam_group.cross-account-access.name}"
  policy_arn = "${aws_iam_policy.self_manage_iam_user.arn}"
}

resource "aws_iam_group_policy_attachment" "cross-account-attach-assume-role" {
  group      = "${aws_iam_group.cross-account-access.name}"
  policy_arn = "${aws_iam_policy.assume_any_role.arn}"
}

resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

resource "aws_iam_group_policy_attachment" "administrators-policy" {
  group      = "${aws_iam_group.administrators.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
