variable "name" {
  type        = string
  description = "The name of the stack"
  default     = "Minimum-SessionExample"
}

variable "create_session_preferences" {
  type        = string
  description = "Whether to create session preferences"
  default     = true
}
