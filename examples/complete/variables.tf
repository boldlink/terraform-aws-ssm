variable "name" {
  type        = string
  description = "The name of the stack"
  default     = "Complete-SessionExample"
}

variable "create_session_preferences" {
  type        = string
  description = "Whether to create session preferences"
  default     = true
}

variable "send_logs_to_s3" {
  type        = bool
  description = "Whether to send session logs to s3 bucket"
  default     = true
}

variable "send_logs_to_cloudwatch" {
  type        = bool
  description = "Whether to send logs to cloudwatch"
  default     = true
}

variable "linux_shell_profile" {
  type        = string
  description = "The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes."
  default     = "sudo su"
}

variable "encrypt_session" {
  type        = bool
  description = "Whether to encrypt the session"
  default     = true
}

variable "logs_expiration_days" {
  type        = number
  description = "Number of days it takes for logs to expire in s3 bucket"
  default     = 45
}

variable "s3_key_prefix" {
  type        = string
  description = "Specify S3 key prefix for the logs"
  default     = "Experimental"
}

variable "tags" {
  description = "Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices."
  type        = map(string)
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    InstanceScheduler  = true
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}
