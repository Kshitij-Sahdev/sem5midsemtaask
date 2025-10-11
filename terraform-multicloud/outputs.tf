output "app_url" {
  value = "https://${module.loadbalancer.public_ip}"
}

output "app_gateway_ip" {
  value = module.loadbalancer.public_ip
}

output "resource_group" {
  value = module.networking.resource_group_name
}

output "vm_ips" {
  value = module.compute.private_ips
}
