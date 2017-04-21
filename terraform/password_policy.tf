resource "aws_iam_account_password_policy" "base_account_password_policy" {
    minimum_password_length        = 20
    require_lowercase_characters   = true
    require_numbers                = true
    require_uppercase_characters   = true
    allow_users_to_change_password = true
}
