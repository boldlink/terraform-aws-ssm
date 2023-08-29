data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_organizations_organization" "org" {}

data "aws_iam_policy_document" "s3" {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["s3:GetEncryptionConfiguration"]
    resources = ["arn:${local.partition}:s3:::${lower(var.name)}"]

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
    resources = ["arn:${local.partition}:s3:::${lower(var.name)}/*"]

    condition {
      test     = "StringEquals"
      variable = "${local.partition}:PrincipalOrgID"
      values   = [data.aws_organizations_organization.org.id]
    }
  }
}
