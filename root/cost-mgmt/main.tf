#
# AWS Billing Alerts
#
# Billing = U$S50
module "aws_cost_mgmt_billing_alert_50" {
  source = "github.com/binbashar/terraform-aws-cost-billing-alarm.git?ref=v1.0.1"

  aws_env                   = "${var.project}-${var.environment}-50"
  monthly_billing_threshold = var.monthly_billing_threshold_50
  currency                  = var.currency
  aws_sns_topic_arn         = data.terraform_remote_state.notifications.outputs.sns_topic_arn_monitoring

  tags = local.tags
}

# Billing = U$S100
module "aws_cost_mgmt_billing_alert_100" {
  source = "github.com/binbashar/terraform-aws-cost-billing-alarm.git?ref=v1.0.1"

  aws_env                   = "${var.project}-${var.environment}-100"
  monthly_billing_threshold = var.monthly_billing_threshold_100
  currency                  = var.currency
  aws_sns_topic_arn         = data.terraform_remote_state.notifications.outputs.sns_topic_arn_monitoring

  tags = local.tags
}

#
# AWS Budget
#
# Budget = U$S100 at 75%
module "aws_cost_mgmt_budget_notif_75" {
  source = "github.com/binbashar/terraform-aws-cost-budget.git?ref=v1.0.2"

  aws_env                = "${var.environment}-75-percent"
  currency               = var.currency
  limit_amount           = var.monthly_billing_threshold_100
  time_unit              = var.time_unit
  time_period_start      = var.time_period_start
  notification_threshold = var.notification_threshold_75
  aws_sns_topic_arn      = data.terraform_remote_state.notifications.outputs.sns_topic_arn_monitoring
  aws_sns_account_id     = var.root_account_id
}

# Budget = U$S100 at 100%
module "aws_cost_mgmt_budget_notif_100" {
  source = "github.com/binbashar/terraform-aws-cost-budget.git?ref=v1.0.2"

  aws_env                = "${var.environment}-100-percent"
  currency               = var.currency
  limit_amount           = var.monthly_billing_threshold_100
  time_unit              = var.time_unit
  time_period_start      = var.time_period_start
  notification_threshold = var.notification_threshold_100
  aws_sns_topic_arn      = data.terraform_remote_state.notifications.outputs.sns_topic_arn_monitoring
  aws_sns_account_id     = var.root_account_id
}
