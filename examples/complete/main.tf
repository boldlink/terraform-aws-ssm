module "complete_example_session" {
  source                     = "../../"
  create_session_preferences = var.create_session_preferences
  name                       = var.name
  send_logs_to_s3            = var.send_logs_to_s3
  send_logs_to_cloudwatch    = var.send_logs_to_cloudwatch
  linux_shell_profile        = var.linux_shell_profile
  encrypt_session            = var.encrypt_session
  logs_expiration_days       = var.logs_expiration_days
  s3_key_prefix              = var.s3_key_prefix
  tags                       = var.tags
}
