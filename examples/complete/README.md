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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete_example_session"></a> [complete\_example\_session](#module\_complete\_example\_session) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_session_preferences"></a> [create\_session\_preferences](#input\_create\_session\_preferences) | Whether to create session preferences | `string` | `true` | no |
| <a name="input_encrypt_session"></a> [encrypt\_session](#input\_encrypt\_session) | Whether to encrypt the session | `bool` | `true` | no |
| <a name="input_linux_shell_profile"></a> [linux\_shell\_profile](#input\_linux\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes. | `string` | `"sudo su"` | no |
| <a name="input_logs_expiration_days"></a> [logs\_expiration\_days](#input\_logs\_expiration\_days) | Number of days it takes for logs to expire in s3 bucket | `number` | `45` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack | `string` | `"Complete-SessionExample"` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Specify S3 key prefix for the logs | `string` | `"Experimental"` | no |
| <a name="input_send_logs_to_cloudwatch"></a> [send\_logs\_to\_cloudwatch](#input\_send\_logs\_to\_cloudwatch) | Whether to send logs to cloudwatch | `bool` | `true` | no |
| <a name="input_send_logs_to_s3"></a> [send\_logs\_to\_s3](#input\_send\_logs\_to\_s3) | Whether to send session logs to s3 bucket | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices. | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "example",<br>  "InstanceScheduler": true,<br>  "LayerId": "Example",<br>  "LayerName": "Example",<br>  "Owner": "Boldlink",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

No outputs.
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
