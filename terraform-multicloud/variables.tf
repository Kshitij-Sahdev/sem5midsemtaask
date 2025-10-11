# AWS vars (for later)
# variable "aws_region" { type = string; default = "us-east-1" }
# variable "aws_access_key" { type = string; sensitive = true }
# variable "aws_secret_key" { type = string; sensitive = true }
# variable "enable_aws" { type = bool; default = false }

# Azure credentials
variable "azure_subscription_id" { type = string; sensitive = true }
variable "azure_client_id" { type = string; sensitive = true }
variable "azure_client_secret" { type = string; sensitive = true }
variable "azure_tenant_id" { type = string; sensitive = true }
variable "azure_location" { type = string; default = "eastus" }
variable "enable_azure" { type = bool; default = true }

# General
variable "environment" { type = string; default = "dev" }
variable "project_name" { type = string; default = "nginx-multicloud" }
variable "vm_size" { type = string; default = "Standard_B1s" }
variable "admin_username" { type = string; default = "azureuser" }
variable "ssh_public_key" { type = string }
