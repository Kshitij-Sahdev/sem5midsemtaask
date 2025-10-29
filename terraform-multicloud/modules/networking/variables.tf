variable "enable_azure" {
  description = "Whether to create Azure networking resources."
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)."
  type        = string
}

variable "location" {
  description = "Azure region to deploy to."
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "tags" {
  description = "Additional tags to merge with defaults."
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Optional override for the resource group name."
  type        = string
  default     = ""
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "public_subnet_prefixes" {
  description = "CIDR prefixes for public subnets."
  type        = list(string)
}

variable "private_subnet_prefixes" {
  description = "CIDR prefixes for private subnets."
  type        = list(string)
}

variable "nat_gateway_enabled" {
  description = "Create NAT gateway resources for private subnet egress."
  type        = bool
  default     = true
}

variable "allowed_inbound_ports" {
  description = "Inbound TCP ports allowed by the network security group."
  type        = list(number)
}
