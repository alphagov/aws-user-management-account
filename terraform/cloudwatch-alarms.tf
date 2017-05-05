variable "environment_name" {
  type = "string"
}

variable "cloudtrail_s3_bucket_name" {
  type = "string"
}

module "aws_security_alarms" {
  source                      = "github.com/alphagov/aws-security-alarms/terraform"
  cloudtrail_s3_bucket_name   = "${var.cloudtrail_s3_bucket_name}"
  cloudtrail_s3_bucket_prefix = "${data.aws_caller_identity.current.account_id}"
}

module "root_activity" {
  source               = "github.com/alphagov/aws-security-alarms/terraform/alarms/root_activity"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "${var.environment_name}"
}

module "unauthorized_activity" {
  source               = "github.com/alphagov/aws-security-alarms/terraform/alarms/unauthorized_activity"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "${var.environment_name}"
}
