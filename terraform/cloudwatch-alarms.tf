module "aws_security_alarms" {
  source                      = "github.com/alphagov/aws-security-alarms/terraform"
  cloudtrail_s3_bucket_name   = "gds-audit-cloudtrails"
  cloudtrail_s3_bucket_prefix = "${data.aws_caller_identity.current.account_id}"
}

module "root_activity" {
  source               = "github.com/alphagov/aws-security-alarms/terraform/alarms/root_activity"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "gds-user-management"
}
