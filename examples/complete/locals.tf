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
  content         = <<DOC
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
