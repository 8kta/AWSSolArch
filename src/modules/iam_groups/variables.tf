variable "group_name" {
  type        = string
  description = "Name of the IAM group"
}

variable "path" {
  type        = string
  description = "Path for the IAM group"
  default     = "/"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to the group"
  default     = []
}

variable "users" {
  type        = list(string)
  description = "List of IAM user names to add to the group"
  default     = []
}
