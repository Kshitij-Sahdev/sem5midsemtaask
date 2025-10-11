# outputs from loadbalancer module

output "dns_name" {
  description = "public DNS/IP of the load balancer"
  value       = var.enable_azure ? azurerm_public_ip.appgw[0].ip_address : ""
}

output "app_gateway_id" {
  description = "ID of the application gateway"
  value       = var.enable_azure ? azurerm_application_gateway.main[0].id : ""
}

output "public_ip" {
  description = "public IP address of app gateway"
  value       = var.enable_azure ? azurerm_public_ip.appgw[0].ip_address : ""
}
