module "session_kms" {
  source           = "boldlink/kms/aws"
  version          = "1.1.0"
  description      = "AWS CMK for encrypting ssm session"
  create_kms_alias = true
  kms_policy       = data.aws_iam_policy_document.kms_policy.json
  alias_name       = "alias/${var.name}-key-alias"
  tags             = var.tags
}

## s3 Bucket
module "session_logs_bucket" {
  source                 = "boldlink/s3/aws"
  version                = "2.3.0"
  bucket                 = lower(var.name)
  force_destroy          = true
  versioning_status      = "Enabled"
  bucket_policy          = data.aws_iam_policy_document.s3.json
  sse_kms_master_key_arn = module.session_kms.arn
  tags                   = var.tags

  lifecycle_configuration = [
    {
      id     = "delete-after-N-days"
      status = "Enabled"

      expiration = [
        {
          days = var.logs_expiration_days
        }
      ]
    }
  ]
}

## session preferences
module "complete_example_session" {
  source                     = "../../"
  create_session_preferences = var.create_session_preferences
  name                       = var.name
  s3_encryption_enabled      = true
  kms_key_id                 = module.session_kms.arn
  s3_bucket_name             = module.session_logs_bucket.id
  linux_shell_profile        = var.linux_shell_profile
  s3_key_prefix              = var.s3_key_prefix
  tags                       = var.tags
}
