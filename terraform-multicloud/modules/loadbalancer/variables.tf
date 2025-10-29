variable "enable_azure" {
  description = "Whether to create Azure load balancer resources."
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "tags" {
  description = "Additional tags to merge with module defaults."
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "Subnet ID for the Application Gateway (public subnet)."
  type        = string
}

variable "backend_ips" {
  description = "List of backend VM private IPs."
  type        = list(string)
  default     = []
}

variable "ports" {
  description = "Port configuration for the Application Gateway."
  type = object({
    http          = number
    https         = number
    backend_https = number
  })
}

variable "probe" {
  description = "Probe configuration for backend health checks."
  type = object({
    path                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    host                = string
  })
}

variable "backend_host" {
  description = "Host header to send to the backend service."
  type        = string
}

variable "sku" {
  description = "SKU configuration for the Application Gateway."
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "ssl_certificate_path" {
  description = "Path to a PFX certificate file for HTTPS termination."
  type        = string
  default     = ""
}

variable "ssl_certificate_base64" {
  description = "Base64-encoded PFX certificate content."
  type        = string
  default     = ""
}

variable "ssl_certificate_password" {
  description = "Password for the PFX certificate."
  type        = string
}
