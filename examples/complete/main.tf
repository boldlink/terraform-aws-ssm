resource "random_string" "bucket" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

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
  bucket                 = lower(local.bucket)
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

## Custom session
module "ec2_policy" {
  source                 = "boldlink/iam-policy/aws"
  version                = "1.1.0"
  policy_name            = "${var.name}-policy"
  policy_attachment_name = "${var.name}-attachment"
  description            = "IAM policy to grant EC2 describe permissions"
  roles                  = [module.ssm_ec2_instance.role_name]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowGetEncryptionConfiguration"
        Action = ["s3:GetEncryptionConfiguration",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = module.session_logs_bucket.arn
      },
      {
        Sid = "AllowkmsDecrypt"
        Action = ["kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Effect   = "Allow"
        Resource = module.session_kms.arn
      },
    ]
  })
  tags = {
    environment        = "examples"
    "user::CostCenter" = "terraform-registry"
  }
}

module "ssm_ec2_instance" {
  source            = "boldlink/ec2/aws"
  version           = "2.0.3"
  name              = "${var.name}-instance"
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = var.instance_type
  monitoring        = var.monitoring
  ebs_optimized     = var.ebs_optimized
  vpc_id            = local.vpc_id
  availability_zone = local.azs
  subnet_id         = local.private_subnets
  tags              = merge({ Name = var.name }, { InstanceScheduler = true }, var.tags)
  root_block_device = var.root_block_device
  install_ssm_agent = var.install_ssm_agent
    security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "custom_session" {
  source                 = "../../"
  name                   = "${var.name}-custom-doc"
  document_version       = "$DEFAULT"
  association_name       = "${var.name}-custom"
  create_custom_document = true
  document_name          = "${var.name}-custom-doc"
  document_format        = var.document_format
  document_type          = var.document_type
  content                = local.content
  targets = [
    {
      key    = "InstanceIds"
      values = [module.ssm_ec2_instance.id]
    }
  ]
  tags = var.tags
  depends_on = [ module.ssm_ec2_instance ]
}
