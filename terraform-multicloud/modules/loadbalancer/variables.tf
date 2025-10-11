# variables for loadbalancer module

variable "enable_azure" {
  description = "whether to create azure resources"
  type        = bool
  default     = true
}

variable "environment" {
  description = "environment name"
  type        = string
}

variable "location" {
  description = "azure region"
  type        = string
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "subnet_id" {
  description = "subnet ID for app gateway (public subnet)"
  type        = string
}

variable "backend_ips" {
  description = "list of backend VM private IPs"
  type        = list(string)
  default     = []
}
