resource "aws_kms_key" "sessionkms" {
  count                   = var.encrypt_session || var.cloudwatch_encryption_enabled || var.s3_encryption_enabled ? 1 : 0
  description             = "AWS CMK for encrypting ssm session"
  deletion_window_in_days = var.key_deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = local.kms_policy
  tags                    = var.tags
}

resource "aws_kms_alias" "sessionkms" {
  count         = var.encrypt_session || var.cloudwatch_encryption_enabled || var.s3_encryption_enabled ? 1 : 0
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.sessionkms[0].key_id
}

resource "aws_cloudwatch_log_group" "ssm_log_group" {
  count             = var.send_logs_to_cloudwatch ? 1 : 0
  name              = "/aws/ssm/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_encryption_enabled ? aws_kms_key.sessionkms[0].arn : null
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
      "s3BucketName" : var.send_logs_to_s3 && var.session_bucket == "" ? aws_s3_bucket.session_logs_bucket[0].id : var.session_bucket,
      "s3KeyPrefix" : var.s3_key_prefix,
      "s3EncryptionEnabled" : var.s3_encryption_enabled,
      "cloudWatchLogGroupName" : var.send_logs_to_cloudwatch ? aws_cloudwatch_log_group.ssm_log_group[0].name : "",
      "cloudWatchEncryptionEnabled" : var.cloudwatch_encryption_enabled,
      "cloudWatchStreamingEnabled" : var.cloudwatch_streaming_enabled,
      "kmsKeyId" : var.encrypt_session ? aws_kms_key.sessionkms[0].key_id : "",
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

### S3 Bucket
resource "aws_s3_bucket" "session_logs_bucket" {
  count         = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  bucket        = lower(var.name)
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.session_logs_bucket[0].id
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_s3_bucket_public_access_block" "session_logs_bucket" {
  count                   = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  bucket                  = aws_s3_bucket.session_logs_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "session_logs_bucket" {
  count  = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.session_logs_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "session_logs_bucket" {
  count  = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.session_logs_bucket[0].id

  rule {
    id     = "delete-after-N-days"
    status = "Enabled"

    expiration {
      days = var.logs_expiration_days
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "session_logs_bucket" {
  count  = var.send_logs_to_s3 && var.create_session_preferences && var.session_bucket == "" && var.s3_encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.session_logs_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sessionkms[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}
