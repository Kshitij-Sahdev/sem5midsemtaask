# PROD - DONT COMMIT

enable_azure        = true
enable_networking   = true
enable_compute      = true
enable_loadbalancer = true
enable_application  = true

azure_subscription_id = "your-prod-subscription-id"
azure_client_id       = "your-prod-client-id"
azure_client_secret   = "your-prod-client-secret"
azure_tenant_id       = "your-prod-tenant-id"
azure_environment     = "public"

environment         = "prod"
project_name        = "nginx-prod"
resource_group_name = ""
tags = {
  owner      = "platform-team"
  costCenter = "prod"
  tier       = "gold"
}

azure_location          = "westus2"
vnet_address_space      = ["10.20.0.0/16"]
public_subnet_prefixes  = ["10.20.1.0/24"]
private_subnet_prefixes = ["10.20.2.0/24"]
nat_gateway_enabled     = true
allowed_inbound_ports   = [22, 80, 443]

vm_count       = 2
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa AAAAB3Nza... your-prod-key"
vm_custom_data = ""

app_gateway_sku = {
  name     = "WAF_v2"
  tier     = "WAF_v2"
  capacity = 2
}
app_gateway_backend_host             = "nginx.internal"
app_gateway_ssl_certificate_path     = "" # provide path to a real cert for production
app_gateway_ssl_certificate_base64   = ""
app_gateway_ssl_certificate_password = "change-me"

application_name = "nginx-prod"

# TODO: add proper cert automation, monitoring, backups, and restrict NSG sources
