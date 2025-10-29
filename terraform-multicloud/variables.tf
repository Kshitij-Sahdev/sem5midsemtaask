variable "enable_azure" {
  description = "Toggle to enable the Azure deployment path."
  type        = bool
  default     = false
}

variable "enable_networking" {
  description = "Create networking resources (resource group, VNet, subnets, NSG, NAT)."
  type        = bool
  default     = true
}

variable "enable_compute" {
  description = "Create compute resources (NICs and virtual machines)."
  type        = bool
  default     = true
}

variable "enable_loadbalancer" {
  description = "Create the Application Gateway load balancer."
  type        = bool
  default     = true
}

variable "enable_application" {
  description = "Expose application level outputs (e.g., nginx app metadata)."
  type        = bool
  default     = true
}

# Azure credentials (optional for local planning)
variable "azure_subscription_id" {
  description = "Azure subscription to deploy into."
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}

variable "azure_client_id" {
  description = "Azure client ID (Service Principal)."
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}

variable "azure_client_secret" {
  description = "Azure client secret."
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID."
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}

variable "azure_environment" {
  description = "Azure cloud environment identifier (public, usgovernment, german, china)."
  type        = string
  default     = "public"
}

variable "azure_location" {
  description = "Default Azure region for resources."
  type        = string
  default     = "eastus"
}

# Naming & tagging
variable "environment" {
  description = "Environment name (dev, qa, prod, etc.)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used as a prefix for resource naming."
  type        = string
  default     = "nginx-multicloud"
}

variable "resource_group_name" {
  description = "Optional override for the resource group name. Leave empty to let the module derive one."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# Networking configuration
variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefixes" {
  description = "CIDR prefixes for public subnets (list index maps to subnet order)."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_prefixes" {
  description = "CIDR prefixes for private subnets (list index maps to subnet order)."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "nat_gateway_enabled" {
  description = "Create a NAT Gateway for outbound access from private subnets."
  type        = bool
  default     = true
}

variable "allowed_inbound_ports" {
  description = "List of inbound TCP ports to allow through the network security group."
  type        = list(number)
  default     = [22, 80, 443]
}

# Compute configuration
variable "vm_count" {
  description = "Number of nginx virtual machines to deploy."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VMs."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key used for VM access."
  type        = string
  default     = ""
}

variable "vm_image" {
  description = "Image reference for the VM deployment."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

variable "vm_custom_data" {
  description = "Custom data (cloud-init) script rendered on VM boot. Leave empty to use the default nginx Docker bootstrap."
  type        = string
  default     = ""
}

variable "vm_os_disk" {
  description = "OS disk configuration for VMs."
  type = object({
    storage_account_type = string
    caching              = string
  })
  default = {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

# Load balancer (Application Gateway) configuration
variable "app_gateway_sku" {
  description = "SKU configuration for the Application Gateway."
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
  default = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
}

variable "app_gateway_ports" {
  description = "Frontend and backend port configuration."
  type = object({
    http          = number
    https         = number
    backend_https = number
  })
  default = {
    http          = 80
    https         = 443
    backend_https = 443
  }
}

variable "app_gateway_probe" {
  description = "Probe configuration for the Application Gateway backend."
  type = object({
    path                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    host                = string
  })
  default = {
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = "127.0.0.1"
  }
}

variable "app_gateway_backend_host" {
  description = "Override host header for backend requests."
  type        = string
  default     = "localhost"
}

variable "app_gateway_ssl_certificate_path" {
  description = "Path to a PFX certificate file for HTTPS termination, left empty to use the module default self-signed certificate."
  type        = string
  default     = ""
}

variable "app_gateway_ssl_certificate_base64" {
  description = "Base64-encoded PFX certificate content. Overrides the path if provided."
  type        = string
  default     = ""
}

variable "app_gateway_ssl_certificate_password" {
  description = "Password for the PFX certificate."
  type        = string
  default     = "realpassword"
}

# Application layer
variable "application_name" {
  description = "Logical application name used by the nginx-app module."
  type        = string
  default     = "nginx-ssl-app"
}
