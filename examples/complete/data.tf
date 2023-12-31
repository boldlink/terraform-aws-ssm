data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "org" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3" {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["s3:GetEncryptionConfiguration"]
    resources = [module.session_logs_bucket.arn]

    condition {
      test     = "StringEquals"
      variable = "${local.partition}:PrincipalOrgID"
      values   = [data.aws_organizations_organization.org.id]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${module.session_logs_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "${local.partition}:PrincipalOrgID"
      values   = [data.aws_organizations_organization.org.id]
    }
  }
}

data "aws_iam_policy_document" "kms_policy" {
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"

  statement {
    sid    = "Allow account/org IAM users to manage kms key"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
      "arn:${local.partition}:iam::${local.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "Allow key usage by log service"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "logs.${local.region}.${local.dns_suffix}"
      ]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]
  }
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*-${var.architecture}-gp2"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.supporting_resources_name}*.pri.*"]
  }
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [var.supporting_resources_name]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
