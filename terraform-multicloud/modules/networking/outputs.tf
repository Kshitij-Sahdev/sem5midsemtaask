# outputs from networking module

output "resource_group_name" {
  description = "name of the resource group"
  value       = var.enable_azure ? azurerm_resource_group.main[0].name : ""
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = var.enable_azure ? azurerm_virtual_network.main[0].id : ""
}

output "public_subnet_id" {
  description = "ID of the public subnet (for load balancer)"
  value       = var.enable_azure ? azurerm_subnet.public[0].id : ""
}

output "private_subnet_id" {
  description = "ID of the private subnet (for VMs)"
  value       = var.enable_azure ? azurerm_subnet.private[0].id : ""
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = var.enable_azure ? azurerm_network_security_group.main[0].id : ""
}
