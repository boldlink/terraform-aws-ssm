locals {
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  bucket     = "${var.name}-${random_string.bucket.result}"
  dns_suffix = data.aws_partition.current.dns_suffix

  subnet_az = [for az in data.aws_subnet.private : az.availability_zone]
  subnet_id = [for i in data.aws_subnet.private : i.id]

  private_subnets = local.subnet_id[2]
  azs             = local.subnet_az[2]
  vpc_id          = data.aws_vpc.supporting.id
  ec2_role_policy = jsonencode({
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
  content = <<DOC
schemaVersion: '2.2'
description: Create test dir in a Linux instance.
parameters: {}
mainSteps:
  - action: 'aws:runShellScript'
    name: "example"
    inputs:
      timeoutSeconds: '60'
      runCommand:
          - mkdir -p /home/testdir
DOC
}
