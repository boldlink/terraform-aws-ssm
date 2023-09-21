locals {
  region                    = data.aws_region.current.name
  partition                 = data.aws_partition.current.partition
  account_id                = data.aws_caller_identity.current.account_id
  dns_suffix                = data.aws_partition.current.dns_suffix
  log_bucket_name           = var.send_logs_to_s3 && var.session_bucket == "" ? try(module.session_logs_bucket[0].id, "") : var.session_bucket
  cloudwatch_log_group_name = var.send_logs_to_cloudwatch ? try(aws_cloudwatch_log_group.ssm_log_group[0].name, "") : ""
  kms_key                   = var.kms_key_id == "" && var.encrypt_session ? try(aws_kms_key.sessionkms[0].key_id, "") : var.kms_key_id
  kms_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow KMS Permissions to Service",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${local.region}.${local.dns_suffix}"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:${local.partition}:iam::${local.account_id}:root"
        },
        "Action" : [
          "kms:*"
        ],
        "Resource" : "*",
      }
    ]
  })
}
