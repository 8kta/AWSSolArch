variable "user_name" {
  type        = string
  description = "Name of the IAM user"
}

variable "path" {
  type        = string
  description = "Path for the IAM user"
  default     = "/"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to the user"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the IAM user"
  default     = {}
}

variable "create_access_key" {
  type        = bool
  description = "Whether to create an access key for the IAM user"
  default     = false
}
