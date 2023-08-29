variable "name" {
  type        = string
  description = "The name of the stack"
}

variable "s3_key_prefix" {
  type        = string
  description = "Specify S3 key prefix for the logs"
  default     = ""
}

variable "run_linux_command" {
  type        = bool
  description = "Specify whether to run command(s) on linux instances"
  default     = false
}

variable "run_windows_command" {
  type        = bool
  description = "Specify whether to run command(s) on windows instances"
  default     = false
}

variable "linux_commands" {
  type        = string
  description = "Specify the content of the script or command. If this is a script, it would be easier to use data source"
  default     = null
}


variable "windows_commands" {
  type        = string
  description = "Specify the content of the script or command. If this is a script, it would be easier to use data source"
  default     = null
}

variable "linux_association_name" {
  type        = string
  description = "The descriptive name for the association."
  default     = "linux-association"
}

variable "windows_association_name" {
  type        = string
  description = "The descriptive name for the association."
  default     = "windows-association"
}

variable "linux_targets" {
  type        = list(string)
  description = "List of instance IDs for the target"
  default     = []
}

variable "windows_targets" {
  type        = list(string)
  description = "List of instance IDs for the windows target"
  default     = []
}

variable "run_command_name" {
  type        = string
  description = "Name of the run command"
  default     = "RunCommandonLinux"
}

variable "run_as_enabled" {
  type        = bool
  description = "If set to true, you must specify a user account that exists on the managed nodes you will be connecting to in the runAsDefaultUser input. Otherwise, sessions will fail to start."
  default     = false
}

variable "run_as_default_user" {
  type        = string
  description = "The name of the user account to start sessions with on Linux managed nodes when the runAsEnabled input is set to true. The user account you specify for this input must exist on the managed nodes you will be connecting to; otherwise, sessions will fail to start."
  default     = ""
}

variable "idle_session_timeout" {
  type        = number
  description = "The amount of time of inactivity you want to allow before a session ends. This input is measured in minutes. Valid values: 1-60"
  default     = 20
}

variable "max_session_duration" {
  type        = number
  description = "The maximum amount of time you want to allow before a session ends. This input is measured in minutes. Valid values: 1-1440"
  default     = 720
}

variable "session_bucket" {
  type        = string
  description = "The name of the bucket to send ssm session logs to"
  default     = ""
}

variable "send_logs_to_s3" {
  type        = bool
  description = "Whether to send session logs to s3 bucket"
  default     = false
}

variable "s3_encryption_enabled" {
  type        = bool
  description = "If set to true, the Amazon S3 bucket you specified in the s3BucketName input must be encrypted."
  default     = true
}

variable "cloudwatch_encryption_enabled" {
  type        = bool
  description = "If set to true, the log group you specified in the cloudWatchLogGroupName input must be encrypted."
  default     = true
}

variable "cloudwatch_streaming_enabled" {
  type        = bool
  description = "If set to true, a continual stream of session data logs are sent to the log group you specified in the cloudWatchLogGroupName input. If set to false, session logs are sent to the log group you specified in the cloudWatchLogGroupName input at the end of your sessions."
  default     = true
}

variable "send_logs_to_cloudwatch" {
  type        = bool
  description = "Whether to send logs to cloudwatch"
  default     = false
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 0
}

variable "encrypt_session" {
  type        = bool
  description = "Whether to encrypt the session using KMS"
  default     = true
}

variable "linux_shell_profile" {
  type        = string
  description = "The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes."
  default     = ""
}

variable "windows_shell_profile" {
  type        = string
  description = "The shell preferences, environment variables, working directories, and commands you specify for sessions on Windows managed nodes."
  default     = ""
}

variable "enable_key_rotation" {
  type        = bool
  description = "Choose whether to enable key rotation"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resources."
  default     = {}
}

variable "key_deletion_window_in_days" {
  type        = number
  description = "The number of days before the key is deleted"
  default     = 7
}

variable "logs_expiration_days" {
  type        = number
  description = "The number of days it will take for logs stored in S3 to expire"
  default     = 30
}

variable "create_session_preferences" {
  type        = string
  description = "Whether to create session preferences"
  default     = false
}
