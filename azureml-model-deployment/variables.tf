
variable "subscription_id" {
  type        = string
  default     = "eastus"
  description = "Azure region for resources"
}

variable "resource_group" {
  type        = string
  default     = "vince-rg"
  description = "Resource group name for the created resources"
}

variable "workspace_name" {
  type        = string
  default     = "vince-dev"
  description = "AML workspace name"
}