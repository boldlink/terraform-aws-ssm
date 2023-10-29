locals {
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  bucket     = "${var.name}-${random_string.bucket.result}"
  dns_suffix = data.aws_partition.current.dns_suffix
  content    = <<DOC
schemaVersion: '1.2'
description: Check ip configuration of a Linux instance.
parameters: {}
runtimeConfig:
  'aws:runShellScript':
    properties:
      - id: '0.aws:runShellScript'
        runCommand:
          - ifconfig
DOC
}
