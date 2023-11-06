variable "name" {
  type        = string
  description = "The name of the stack"
  default     = "Complete-Example"
}

variable "create_session_preferences" {
  type        = string
  description = "Whether to create session preferences"
  default     = true
}

variable "linux_shell_profile" {
  type        = string
  description = "The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes."
  default     = "sudo su"
}

variable "logs_expiration_days" {
  type        = number
  description = "Number of days it takes for logs to expire in s3 bucket"
  default     = 45
}

variable "s3_key_prefix" {
  type        = string
  description = "Specify S3 key prefix for the logs"
  default     = "ssm/logs"
}

variable "tags" {
  description = "Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices."
  type        = map(string)
  default = {
    Environment        = "Example"
    "user::CostCenter" = "terraform-registry"
    InstanceScheduler  = true
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}

variable "document_type" {
  type        = string
  description = "The type of the document. Valid document types include: `Automation`, `Command`, `Package`, `Policy`, and `Session`"
  default     = "Command"
}

variable "document_format" {
  type        = string
  description = "The format of the document. Valid document types include: `JSON` and `YAML`"
  default     = "YAML"
}

variable "supporting_resources_name" {
  description = "Name of supporting resource VPC"
  type        = string
  default     = "terraform-aws-ssm"
}

variable "instance_type" {
  description = "The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance"
  type        = string
  default     = "t3.small"
}

variable "architecture" {
  type        = string
  description = "The architecture of the instance to launch"
  default     = "x86_64"
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled which pulls every 1m and adds additonal cost, default monitoring doesn't add costs"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = true
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance."
  type        = list(any)
  default = [
    {
      volume_size = 15
      encrypted   = true
    }
  ]
}

variable "install_ssm_agent" {
  type        = bool
  description = "Whether to install ssm agent"
  default     = true
}
