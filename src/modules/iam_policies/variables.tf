variable "policy_name" {
  type        = string
  description = "Name of the IAM policy"
}

variable "path" {
  type        = string
  description = "Path for the IAM policy"
  default     = "/"
}

variable "description" {
  type        = string
  description = "Description of the IAM policy"
  default     = ""
}

variable "policy_document" {
  type        = string
  description = "JSON policy document"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the policy"
  default     = {}
}
