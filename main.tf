resource "aws_kms_key" "sessionkms" {
  count                   = var.kms_key_id == "" && (var.encrypt_session || var.cloudwatch_encryption_enabled || var.s3_encryption_enabled) ? 1 : 0
  description             = "AWS CMK for encrypting ssm session"
  deletion_window_in_days = var.key_deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = data.aws_iam_policy_document.kms_policy.json
  tags                    = var.tags
}

resource "aws_kms_alias" "sessionkms" {
  count         = var.kms_key_id == "" && (var.encrypt_session || var.cloudwatch_encryption_enabled || var.s3_encryption_enabled) ? 1 : 0
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.sessionkms[0].key_id
}

resource "aws_cloudwatch_log_group" "ssm_log_group" {
  count             = var.send_logs_to_cloudwatch ? 1 : 0
  name              = "/aws/ssm/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_encryption_enabled && var.kms_key_id == "" ? try(aws_kms_key.sessionkms[0].arn, null) : null
  tags              = var.tags
}

### custom document
resource "aws_ssm_document" "custom" {
  count           = var.create_custom_document ? 1 : 0
  name            = var.document_name
  document_type   = var.document_type
  document_format = var.document_format
  tags            = var.tags
  content         = var.content
}

resource "aws_ssm_association" "main" {
  count            = var.association_name != null ? 1 : 0
  name             = aws_ssm_document.custom[0].name
  document_version = try(var.document_version, "$LATEST")
  association_name = var.association_name

  dynamic "targets" {
    for_each = var.targets
    content {
      key    = try(targets.value.key, null)
      values = try(targets.value.values, null)
    }
  }
}

## Session preferences
resource "aws_ssm_document" "session_preferences" {
  count           = var.create_session_preferences ? 1 : 0
  name            = var.name
  document_type   = "Session"
  document_format = "JSON"
  tags            = var.tags
  content = jsonencode({
    "schemaVersion" : "1.0",
    "description" : "Document to hold regional settings for Session Manager",
    "sessionType" : "Standard_Stream",
    "inputs" : {
      "s3BucketName" : local.log_bucket_name,
      "s3KeyPrefix" : var.s3_key_prefix,
      "s3EncryptionEnabled" : var.s3_encryption_enabled,
      "cloudWatchLogGroupName" : local.cloudwatch_log_group_name,
      "cloudWatchEncryptionEnabled" : var.cloudwatch_encryption_enabled,
      "cloudWatchStreamingEnabled" : var.cloudwatch_streaming_enabled,
      "kmsKeyId" : local.kms_key,
      "runAsEnabled" : var.run_as_enabled,
      "runAsDefaultUser" : var.run_as_default_user,
      "idleSessionTimeout" : var.idle_session_timeout,
      "maxSessionDuration" : var.max_session_duration,
      "shellProfile" : {
        "windows" : var.windows_shell_profile,
        "linux" : var.linux_shell_profile
      }
    }
  })
}

## s3 Bucket
module "session_logs_bucket" {
  count                  = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  source                 = "boldlink/s3/aws"
  version                = "2.3.0"
  bucket                 = lower(var.name)
  force_destroy          = true
  versioning_status      = "Enabled"
  bucket_policy          = data.aws_iam_policy_document.combined_s3_policy.json
  sse_kms_master_key_arn = var.encrypt_session && var.kms_key_id == "" ? try(aws_kms_key.sessionkms[0].arn, null) : null
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
