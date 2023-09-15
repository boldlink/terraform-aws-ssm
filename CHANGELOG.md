# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- fix: `S3 error- A conflicting conditional operation is currently in progress against this resource` when deleting the resources on the first `terraform destroy`. One has to wait for some seconds to run the `terraform destroy` command again to destroy the s3 resources.
- fix: logs not showing on s3 bucket created by module
- feat: showcase usage of other types of documents in the complete example
- feat: Add parameter store
- feat: Show in complete example the usage of run commands
- feat: Add more systems manager feature like `Patch Manager`, `Maintenance Window` among others
- fix: CKV_AWS_300 Ensure S3 lifecycle configuration sets period for aborting failed uploads
- fix: CKV_AWS_144 Ensure that S3 bucket has cross-region replication enabled
- fix: CKV2_AWS_62 Ensure S3 buckets should have event notifications enabled
- fix: CKV_AWS_18 Ensure the S3 bucket has access logging enabled

## [1.0.0] - 2023-08-28
### Description
- feat: Added configuration for SSM session
- feat: Added S3 resources for logging ssm session
- feat: Added cloudwatch resources for sending session logs
- feat: Added KMS resources for encryption of logs and session
- feat: Added run command resources for linux
- feat: Added run command resources for windows

## [0.1.0] - 2023-08-23
### Description
- Initial commit
- Added files from template repository

[Unreleased]: https://github.com/boldlink/terraform-aws-ssm/compare/1.0.0...HEAD

[1.0.0]: https://github.com/boldlink/terraform-aws-ssm/releases/tag/1.0.0
[0.1.0]: https://github.com/boldlink/terraform-aws-ssm/releases/tag/0.1.0
