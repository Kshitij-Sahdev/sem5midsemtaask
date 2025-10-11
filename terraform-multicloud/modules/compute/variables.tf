# variables for compute module

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
  description = "azure region"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group (created by networking module)"
  type        = string
}

variable "subnet_id" {
  description = "id of the subnet to deploy VMs into (private subnet)"
  type        = string
}

variable "vm_size" {
  description = "azure vm size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "ssh public key for vm access"
  type        = string
}
