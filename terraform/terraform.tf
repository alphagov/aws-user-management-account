terraform {
  required_version = "0.12.20"

  backend "s3" {
    bucket = "gds-user-management-terraform"
    key    = "terraform/state/user-management-account"
    region = "eu-west-2"
  }
}

provider "aws" {
  version = "~> 2.0"
}
