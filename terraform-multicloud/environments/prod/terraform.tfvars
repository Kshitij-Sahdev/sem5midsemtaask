# PROD - DONT COMMIT
azure_subscription_id = "your-prod-subscription-id"
azure_client_id       = "your-prod-client-id"
azure_client_secret   = "your-prod-client-secret"
azure_tenant_id       = "your-prod-tenant-id"

azure_location = "westus2"
environment    = "prod"
project_name   = "nginx-prod"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa AAAAB3Nza... your-prod-key"
enable_azure   = true

# TODO: proper certs, monitoring, backups, restrict NSG
