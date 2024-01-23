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
* This module allows you to create a custom session document with the following definitions:
   * Cloudwatch Logs w/encryption.
   * S3 Logs bucket w/encryption.
   * Session KMS key for encryption at rest.
* With this module you can also create custom documents to execute on your instances with SSM Agent enabled.

**NOTE:**
* You can change the default AWS SSM session `SSM-SessionManagerRunShell` by importing it first to your state and then apply the module changes.
* We highly recommend you to condition which session document for SSM Session you allow users to use, this will restrict users to start the SSM Sessions using their own custom documents or the default document (SSM-SessionManagerRunShell) otherwise you will make whatever session document you configured redundant, see the AWS documentation for this [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-sessiondocumentaccesscheck.html).

Examples available [`here`](./examples)

## Permissions Required by EC2 instance profile
The following KMS permissions are required by instance profile to decrypt session using the KMS key created by the module:
```console
 "kms:Decrypt",
 "kms:GenerateDataKey"
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
  version                    = "<latest_module_version>"
  name                       = var.name
  encrypt_session            = true
  create_session_preferences = var.create_session_preferences
}
```

## Using the Custom Document In Your SSM Session
To use this Session document in a session initiate a session with the following cli command (ensure ssm plugin is installed in your system first). See [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) for more details on how to install.
```console
aws ssm start-session \
    --target "<instance_id_here>"
    --document-name "<name_of_created_session_document>"
```

## Documentation

[Amazon Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)

[Terraform resource documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ssm_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ssm_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_document.session_preferences](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_name"></a> [association\_name](#input\_association\_name) | The descriptive name for the association. | `string` | `null` | no |
| <a name="input_cloudwatch_encryption_enabled"></a> [cloudwatch\_encryption\_enabled](#input\_cloudwatch\_encryption\_enabled) | If set to true, the log group you specified in the cloudWatchLogGroupName input must be encrypted. | `bool` | `true` | no |
| <a name="input_cloudwatch_streaming_enabled"></a> [cloudwatch\_streaming\_enabled](#input\_cloudwatch\_streaming\_enabled) | If set to true, a continual stream of session data logs are sent to the log group you specified in the cloudWatchLogGroupName input. If set to false, session logs are sent to the log group you specified in the cloudWatchLogGroupName input at the end of your sessions. | `bool` | `true` | no |
| <a name="input_content"></a> [content](#input\_content) | The JSON or YAML content of the document. | `string` | `""` | no |
| <a name="input_create_custom_document"></a> [create\_custom\_document](#input\_create\_custom\_document) | Specify whether to create ssm document with custom settings | `bool` | `false` | no |
| <a name="input_create_session_preferences"></a> [create\_session\_preferences](#input\_create\_session\_preferences) | Whether to create session preferences | `string` | `false` | no |
| <a name="input_document_format"></a> [document\_format](#input\_document\_format) | The format of the document. Valid document types include: `JSON` and `YAML` | `string` | `"JSON"` | no |
| <a name="input_document_name"></a> [document\_name](#input\_document\_name) | The name of the custom document | `string` | `null` | no |
| <a name="input_document_type"></a> [document\_type](#input\_document\_type) | The type of the document. Valid document types include: `Automation`, `Command`, `Package`, `Policy`, and `Session` | `string` | `null` | no |
| <a name="input_document_version"></a> [document\_version](#input\_document\_version) | The document version you want to associate with the target(s). Can be a specific version or the default version. | `string` | `null` | no |
| <a name="input_idle_session_timeout"></a> [idle\_session\_timeout](#input\_idle\_session\_timeout) | The amount of time of inactivity you want to allow before a session ends. This input is measured in minutes. Valid values: 1-60 | `number` | `20` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Provide a KMS Key ID for AWS CMK key not created by this module | `string` | `""` | no |
| <a name="input_linux_shell_profile"></a> [linux\_shell\_profile](#input\_linux\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes. | `string` | `""` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The maximum amount of time you want to allow before a session ends. This input is measured in minutes. Valid values: 1-1440 | `number` | `720` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `0` | no |
| <a name="input_run_as_default_user"></a> [run\_as\_default\_user](#input\_run\_as\_default\_user) | The name of the user account to start sessions with on Linux managed nodes when the runAsEnabled input is set to true. The user account you specify for this input must exist on the managed nodes you will be connecting to; otherwise, sessions will fail to start. | `string` | `""` | no |
| <a name="input_run_as_enabled"></a> [run\_as\_enabled](#input\_run\_as\_enabled) | If set to true, you must specify a user account that exists on the managed nodes you will be connecting to in the runAsDefaultUser input. Otherwise, sessions will fail to start. | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the bucket to send ssm session logs to | `string` | `""` | no |
| <a name="input_s3_encryption_enabled"></a> [s3\_encryption\_enabled](#input\_s3\_encryption\_enabled) | If set to true, the Amazon S3 bucket you specified in the s3BucketName input must be encrypted. | `bool` | `true` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Specify S3 key prefix for the logs | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | The configuration for the targets to associate the Document with. As of this version AWS currently supports a maximum of 5 targets. | `list(any)` | `[]` | no |
| <a name="input_windows_shell_profile"></a> [windows\_shell\_profile](#input\_windows\_shell\_profile) | The shell preferences, environment variables, working directories, and commands you specify for sessions on Windows managed nodes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_document_type"></a> [document\_type](#output\_document\_type) | The type of the document |
| <a name="output_name"></a> [name](#output\_name) | The name of the session document |
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
