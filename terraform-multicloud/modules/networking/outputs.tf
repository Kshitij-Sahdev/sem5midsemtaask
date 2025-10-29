# Outputs from networking module

locals {
  ordered_public_subnets  = var.enable_azure ? [for key in sort(keys(local.public_subnets)) : azurerm_subnet.public[key].id] : []
  ordered_private_subnets = var.enable_azure ? [for key in sort(keys(local.private_subnets)) : azurerm_subnet.private[key].id] : []
}

output "resource_group_name" {
  description = "Name of the resource group."
  value       = var.enable_azure ? local.resource_group_name : ""
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = var.enable_azure && length(azurerm_virtual_network.main) > 0 ? azurerm_virtual_network.main[0].id : ""
}

output "public_subnet_id" {
  description = "ID of the first public subnet (for backward compatibility)."
  value       = length(local.ordered_public_subnets) > 0 ? local.ordered_public_subnets[0] : ""
}

output "public_subnet_ids" {
  description = "IDs of all public subnets."
  value       = local.ordered_public_subnets
}

output "private_subnet_id" {
  description = "ID of the first private subnet (for backward compatibility)."
  value       = length(local.ordered_private_subnets) > 0 ? local.ordered_private_subnets[0] : ""
}

output "private_subnet_ids" {
  description = "IDs of all private subnets."
  value       = local.ordered_private_subnets
}

output "nsg_id" {
  description = "ID of the network security group."
  value       = var.enable_azure && length(azurerm_network_security_group.main) > 0 ? azurerm_network_security_group.main[0].id : ""
}
