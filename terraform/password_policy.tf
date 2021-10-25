resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length        = 15
  allow_users_to_change_password = true
}
