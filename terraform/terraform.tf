terraform {
  backend "s3" {
    bucket = "gds-user-management-terraform"
    key    = "terraform/state/user-management-account"
  }
}
