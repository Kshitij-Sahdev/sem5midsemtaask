variable "enable_azure" {
  description = "Whether to create Azure compute resources."
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)."
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group (created by networking module)."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to deploy VMs into (typically private)."
  type        = string
}

variable "tags" {
  description = "Additional tags to merge with module defaults."
  type        = map(string)
  default     = {}
}

variable "vm_count" {
  description = "Number of VMs to deploy."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
}

variable "vm_image" {
  description = "Image reference for the VM deployment."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "vm_os_disk" {
  description = "OS disk configuration for VMs."
  type = object({
    storage_account_type = string
    caching              = string
  })
}

variable "admin_username" {
  description = "Admin username for the VM."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access."
  type        = string
}

variable "vm_custom_data" {
  description = "Custom data (cloud-init) script. If empty, a default nginx bootstrap script is used."
  type        = string
  default     = ""
}
