output "resource_group_name" {
  description = "Name of the resource group created (or referenced)."
  value       = module.networking.resource_group_name
}

output "virtual_network_id" {
  description = "ID of the deployed virtual network."
  value       = module.networking.vnet_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = module.networking.private_subnet_ids
}

output "application_gateway_public_ip" {
  description = "Public IP assigned to the Application Gateway."
  value       = module.loadbalancer.public_ip
}

output "application_gateway_dns" {
  description = "DNS/IP of the load balancer endpoint."
  value       = module.loadbalancer.dns_name
}

output "vm_private_ips" {
  description = "Private IP addresses of the deployed VMs."
  value       = module.compute.private_ips
}

output "vm_ids" {
  description = "IDs of the deployed VMs."
  value       = module.compute.vm_ids
}

output "application_info" {
  description = "Application metadata for downstream integrations."
  value       = module.nginx_app.info
}
