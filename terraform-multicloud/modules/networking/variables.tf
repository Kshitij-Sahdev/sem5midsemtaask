# variables for networking module

variable "enable_azure" {
  description = "whether to create azure resources"
  type        = bool
  default     = true
}

variable "environment" {
  description = "environment name (dev, prod, etc)"
  type        = string
}

variable "location" {
  description = "azure region to deploy to"
  type        = string
}

variable "project_name" {
  description = "project name for resource naming"
  type        = string
}
