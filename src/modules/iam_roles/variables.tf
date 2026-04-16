variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "path" {
  type        = string
  description = "Path for the IAM role"
  default     = "/"
}

variable "description" {
  type        = string
  description = "Description of the IAM role"
  default     = ""
}

variable "assume_role_policy" {
  type        = string
  description = "JSON policy document for assume role"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of policy ARNs to attach to the role"
  default     = []
}

variable "create_instance_profile" {
  type        = bool
  description = "Whether to create an instance profile for EC2"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the role"
  default     = {}
}
