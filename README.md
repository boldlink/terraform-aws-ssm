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

# Terraform AWS Systems Manager module
This module simplifies the process of creating AWS Systems Manager sessions, offering options to enable session encryption, CloudWatch Logs encryption and S3 Logs encryption. The module also assists in generating run command documents for both Linux and Windows instances. This assists one to execute commands simultaneously across instances managed by AWS Systems Manager.

## Advantages of Using this Module
- **Ease of Use:** The module provides straightforward examples.
- **Simplified Resource Setup:** The module eliminates complexities associated with configuring the essential resources required to run AWS Systems Manager sessions.
- **Best Practice Compliance:** The module adheres to AWS best practices, using tools like Checkov to scan for potential security vulnerabilities.

Examples available [`here`](./examples)

## Permissions Required by EC2 instance profile
The following permissions are required by instance profile to dycrypt session using the KMS key created by the module:
```console
{
    "Effect": "Allow",
    "Principal": {
        "AWS": "*"
    },
    "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey"
    ],
    "Resource": "*"
}
```

## Permissions Required by IAM USER
In addition to having the required permissions for ssm actions, the IAM user using the session requires the following permissions
```console
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PutObjectsBucket",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::<bucket_name>/*"
        },
        {
            "Sid": "ListBucketAndEncryptionConfig",
            "Action": [
                "s3:GetEncryptionConfiguration"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::<bucket_name>"
        },
        {
            "Sid": "S3KMSSessionManagerKMS",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey*"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1:ACCOUNTId:key/YOUR-KMS-FOR-SessionManagerEncryption",
                "arn:aws:kms:us-east-1:ACCOUNTID:key/YOUR-KMS-FOR-S3BucketEncryption"
            ]
        }
    ]
}
```


## Usage
**NOTE**: These examples use the latest version of this module

```hcl
module "miniumum" {
  source                     = "boldlink/ssm/aws"
  version                    = "<provider_version_here>"
  name                       = var.name
  create_session_preferences = var.create_session_preferences
}
```

## Using the Document in Session
To use this Session document in a session initiate a session with the following cli command (ensure ssm plugin is installed in your system first). See [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) for more details on how to install.
```console
aws ssm start-session \
    --target "<instance_id_here>"
    --document-name "<name_of_created_session_document>"
```
**Note:** The `encrypt_session` option is set to `true` by default hence the session will be encrypted. You can turn it off by changing the value to `false`.

## Restricting Users to use Session Document at Account Level
- SCPs can be used to ensure that IAM users use only the custom document created here for ssm sessions

## Documentation

[Amazon Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)

[Terraform resource documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ssm_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.sessionkms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.sessionkms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.session_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.session_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.session_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.session_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.session_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_ssm_association.linux_run_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_association.windows_run_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.linux_run_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_document.session_preferences](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_document.windows_run_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_encryption_enabled"></a> [cloudwatch\_encryption\_enabled](#input\_cloudwatch\_encryption\_enabled) | If set to true, the log group you specified in the cloudWatchLogGroupName input must be encrypted. | `bool` | `true` | no |
| <a name="input_cloudwatch_streaming_enabled"></a> [cloudwatch\_streaming\_enabled](#input\_cloudwatch\_streaming\_enabled) | If set to true, a continual stream of session data logs are sent to the log group you specified in the cloudWatchLogGroupName input. If set to false, session logs are sent to the log group you specified in the cloudWatchLogGroupName input at the end of your sessions. | `bool` | `true` | no |
| <a name="input_create_session_preferences"></a> [create\_session\_preferences](#input\_create\_session\_preferences) | Whether to create session preferences | `string` | `false` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Choose whether to enable key rotation | `bool` | `true` | no |
| <a name="input_encrypt_session"></a> [encrypt\_session](#input\_encrypt\_session) | Whether to encrypt the session using KMS | `bool` | `true` | no |
| <a name="input_idle_session_timeout"></a> [idle\_session\_timeout](#input\_idle\_session\_timeout) | The amount of time of inactivity you want to allow before a session ends. This input is measured in minutes. Valid values: 1-60 | `number` | `20` | no |
| <a name="input_key_deletion_window_in_days"></a> [key\_deletion\_window\_in\_days](#input\_key\_deletion\_window\_in\_days) | The number of days before the key is deleted | `number` | `7` | no |
| <a name="input_linux_association_name"></a> [linux\_association\_name](#input\_linux\_association\_name) | The descriptive name for the association. | `string` | `"linux-association"` | no |
| <a name="input_linux_commands"></a> [linux\_commands](#input\_linux\_commands) | Specify the content of the script or command. If this is a script, it would be easier to use data source | `string` | `null` | no |
| <a name="input_linux_shell_profile"></a> [linux\_shell\_profile](#input\_linux\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes. | `string` | `""` | no |
| <a name="input_linux_targets"></a> [linux\_targets](#input\_linux\_targets) | List of instance IDs for the target | `list(string)` | `[]` | no |
| <a name="input_logs_expiration_days"></a> [logs\_expiration\_days](#input\_logs\_expiration\_days) | The number of days it will take for logs stored in S3 to expire | `number` | `30` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The maximum amount of time you want to allow before a session ends. This input is measured in minutes. Valid values: 1-1440 | `number` | `720` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `0` | no |
| <a name="input_run_as_default_user"></a> [run\_as\_default\_user](#input\_run\_as\_default\_user) | The name of the user account to start sessions with on Linux managed nodes when the runAsEnabled input is set to true. The user account you specify for this input must exist on the managed nodes you will be connecting to; otherwise, sessions will fail to start. | `string` | `""` | no |
| <a name="input_run_as_enabled"></a> [run\_as\_enabled](#input\_run\_as\_enabled) | If set to true, you must specify a user account that exists on the managed nodes you will be connecting to in the runAsDefaultUser input. Otherwise, sessions will fail to start. | `bool` | `false` | no |
| <a name="input_run_command_name"></a> [run\_command\_name](#input\_run\_command\_name) | Name of the run command | `string` | `"RunCommandonLinux"` | no |
| <a name="input_run_linux_command"></a> [run\_linux\_command](#input\_run\_linux\_command) | Specify whether to run command(s) on linux instances | `bool` | `false` | no |
| <a name="input_run_windows_command"></a> [run\_windows\_command](#input\_run\_windows\_command) | Specify whether to run command(s) on windows instances | `bool` | `false` | no |
| <a name="input_s3_encryption_enabled"></a> [s3\_encryption\_enabled](#input\_s3\_encryption\_enabled) | If set to true, the Amazon S3 bucket you specified in the s3BucketName input must be encrypted. | `bool` | `true` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Specify S3 key prefix for the logs | `string` | `""` | no |
| <a name="input_send_logs_to_cloudwatch"></a> [send\_logs\_to\_cloudwatch](#input\_send\_logs\_to\_cloudwatch) | Whether to send logs to cloudwatch | `bool` | `false` | no |
| <a name="input_send_logs_to_s3"></a> [send\_logs\_to\_s3](#input\_send\_logs\_to\_s3) | Whether to send session logs to s3 bucket | `bool` | `false` | no |
| <a name="input_session_bucket"></a> [session\_bucket](#input\_session\_bucket) | The name of the bucket to send ssm session logs to | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_windows_association_name"></a> [windows\_association\_name](#input\_windows\_association\_name) | The descriptive name for the association. | `string` | `"windows-association"` | no |
| <a name="input_windows_commands"></a> [windows\_commands](#input\_windows\_commands) | Specify the content of the script or command. If this is a script, it would be easier to use data source | `string` | `null` | no |
| <a name="input_windows_shell_profile"></a> [windows\_shell\_profile](#input\_windows\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Windows managed nodes. | `string` | `""` | no |
| <a name="input_windows_targets"></a> [windows\_targets](#input\_windows\_targets) | List of instance IDs for the windows target | `list(string)` | `[]` | no |

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

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```

#### BOLDLink-SIG 2023
