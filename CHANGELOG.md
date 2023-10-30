# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: showcase usage of other types of documents in the complete example
- feat: Add parameter store
- feat: Show in complete example the usage of run commands
- feat: Add more systems manager feature like `Patch Manager`, `Maintenance Window` among others

## [1.0.1] - 2023-10-30
- fix: logs not showing on s3 bucket created by module
- added custom ssm document in complete example
- added a target in complete example
- added VPC as a supporting resource

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
