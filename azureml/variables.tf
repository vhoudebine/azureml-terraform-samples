variable "workspace_name" {
  type        = string
  default     = "vince-dev"
  description = "AML workspace name"
}

variable "region" {
  type        = string
  default     = "eastus"
  description = "Azure region for resources"
}

variable "resource_group" {
  type        = string
  default     = "vince-rg"
  description = "Resource group name for the created resources"
}

variable "cluster_name" {
  type        = string
  default     = "terraform-test"
  description = "AML compute cluster name"
}

variable "node_type" {
  type        = string
  default     = "STANDARD_DS3_v2"
  description = "VM type for the cluster nodes"
}

variable "max_cluster_nodes" {
  type        = number
  default     = 1
  description = "Max number of nodes in the AML compute cluster"
}