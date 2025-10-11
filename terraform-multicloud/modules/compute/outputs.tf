# outputs from compute module

output "private_ips" {
  description = "private IP addresses of the VMs"
  value       = var.enable_azure ? azurerm_network_interface.nginx_nic[*].private_ip_address : []
}

output "vm_ids" {
  description = "IDs of the created VMs"
  value       = var.enable_azure ? azurerm_linux_virtual_machine.nginx_vm[*].id : []
}

output "nic_ids" {
  description = "network interface IDs"
  value       = var.enable_azure ? azurerm_network_interface.nginx_nic[*].id : []
}
