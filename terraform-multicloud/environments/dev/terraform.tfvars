# DONT COMMIT THIS FILE

enable_azure        = false
enable_networking   = true
enable_compute      = true
enable_loadbalancer = true
enable_application  = true

azure_subscription_id = "nakhli-subscription-id"
azure_client_id       = "naklhi-client-id"
azure_client_secret   = "nakhli-client-secret"
azure_tenant_id       = "nakhli-tenant-id"
azure_environment     = "public"

environment         = "dev"
project_name        = "nginx-demo"
resource_group_name = ""
tags = {
  owner = "dev-team"
  env   = "dev"
}

azure_location          = "eastus"
vnet_address_space      = ["10.10.0.0/16"]
public_subnet_prefixes  = ["10.10.1.0/24"]
private_subnet_prefixes = ["10.10.2.0/24"]
nat_gateway_enabled     = true
allowed_inbound_ports   = [22, 80, 443]

vm_count       = 1
vm_size        = "Standard_B1s"
admin_username = "realazureuser"
ssh_public_key = "ssh-rsa <shhkey>"
vm_custom_data = ""

app_gateway_sku = {
  name     = "Standard_v2"
  tier     = "Standard_v2"
  capacity = 1
}
app_gateway_backend_host = "localhost"

application_name = "devopssem5-nginx-ssl-app"
