[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-ssm/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-ssm.svg)](https://github.com/boldlink/terraform-aws-ssm/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ssm/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ssm/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform  module example of complete and most common configuration

**NOTE** Terraform version 0.14.11 
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0, <= 5.15.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.15.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete_example_session"></a> [complete\_example\_session](#module\_complete\_example\_session) | ../../ | n/a |
| <a name="module_custom_session"></a> [custom\_session](#module\_custom\_session) | ../../ | n/a |
| <a name="module_session_kms"></a> [session\_kms](#module\_session\_kms) | boldlink/kms/aws | 1.1.0 |
| <a name="module_session_logs_bucket"></a> [session\_logs\_bucket](#module\_session\_logs\_bucket) | boldlink/s3/aws | 2.3.0 |
| <a name="module_ssm_ec2_instance"></a> [ssm\_ec2\_instance](#module\_ssm\_ec2\_instance) | boldlink/ec2/aws | 2.0.1 |

## Resources

| Name | Type |
|------|------|
| [random_string.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | The architecture of the instance to launch | `string` | `"x86_64"` | no |
| <a name="input_create_session_preferences"></a> [create\_session\_preferences](#input\_create\_session\_preferences) | Whether to create session preferences | `string` | `true` | no |
| <a name="input_document_format"></a> [document\_format](#input\_document\_format) | The format of the document. Valid document types include: `JSON` and `YAML` | `string` | `"YAML"` | no |
| <a name="input_document_type"></a> [document\_type](#input\_document\_type) | The type of the document. Valid document types include: `Automation`, `Command`, `Package`, `Policy`, and `Session` | `string` | `"Command"` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `true` | no |
| <a name="input_install_ssm_agent"></a> [install\_ssm\_agent](#input\_install\_ssm\_agent) | Whether to install ssm agent | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance | `string` | `"t3.small"` | no |
| <a name="input_linux_shell_profile"></a> [linux\_shell\_profile](#input\_linux\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes. | `string` | `"sudo su"` | no |
| <a name="input_logs_expiration_days"></a> [logs\_expiration\_days](#input\_logs\_expiration\_days) | Number of days it takes for logs to expire in s3 bucket | `number` | `45` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled which pulls every 1m and adds additonal cost, default monitoring doesn't add costs | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack | `string` | `"Complete-Example"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Configuration block to customize details about the root block device of the instance. | `list(any)` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": 15<br>  }<br>]</pre> | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Specify S3 key prefix for the logs | `string` | `"ssm/logs"` | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | Name of supporting resource VPC | `string` | `"terraform-aws-ssm"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices. | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "Example",<br>  "InstanceScheduler": true,<br>  "LayerId": "Example",<br>  "LayerName": "Example",<br>  "Owner": "Boldlink",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_document_type"></a> [document\_type](#output\_document\_type) | The document type |
| <a name="output_document_type2"></a> [document\_type2](#output\_document\_type2) | The document type |
| <a name="output_name"></a> [name](#output\_name) | Name of the session document |
| <a name="output_name2"></a> [name2](#output\_name2) | Name of the session document |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

#### BOLDLink-SIG 2022
