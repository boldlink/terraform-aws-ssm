variable "name" {
  type        = string
  description = "The name of the stack"
  default     = "Minimum-SessionExample"
}

variable "create_session_preferences" {
  type        = bool
  description = "Whether to create session preferences"
  default     = true
}

variable "linux_shell_profile" {
  type        = string
  description = "The shell preferences, environment variables, working directories, and commands you specify for sessions on Linux managed nodes."
  default     = "pwd"
}
