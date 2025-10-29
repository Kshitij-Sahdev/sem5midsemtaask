variable "enable_application" {
  description = "Whether to expose application-level outputs."
  type        = bool
  default     = true
}

variable "application_name" {
  description = "Friendly name of the deployed application."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "lb_dns" {
  description = "Load balancer DNS/IP."
  type        = string
}
