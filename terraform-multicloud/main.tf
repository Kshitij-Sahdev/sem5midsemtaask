terraform {
  required_version = ">= 1.3.0"
  required_providers {
    # aws = { source = "hashicorp/aws", version = "~> 5.0" }  # TODO: add when i get credits
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }

  # backend "azurerm" {  # TODO: setup remote state
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "tfstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}

  environment                 = var.azure_environment
  subscription_id             = var.enable_azure && var.azure_subscription_id != null ? var.azure_subscription_id : null
  client_id                   = var.enable_azure && var.azure_client_id != null ? var.azure_client_id : null
  client_secret               = var.enable_azure && var.azure_client_secret != null ? var.azure_client_secret : null
  tenant_id                   = var.enable_azure && var.azure_tenant_id != null ? var.azure_tenant_id : null
  skip_provider_registration  = true
  skip_credentials_validation = !var.enable_azure
  use_cli                     = false
} # null for verification and not hardcoded

module "networking" {
  source                  = "./modules/networking"
  enable_azure            = var.enable_azure && var.enable_networking
  environment             = var.environment
  project_name            = var.project_name
  location                = var.azure_location
  tags                    = var.tags
  resource_group_name     = var.resource_group_name
  vnet_address_space      = var.vnet_address_space
  public_subnet_prefixes  = var.public_subnet_prefixes
  private_subnet_prefixes = var.private_subnet_prefixes
  nat_gateway_enabled     = var.nat_gateway_enabled
  allowed_inbound_ports   = var.allowed_inbound_ports
}

module "compute" {
  source              = "./modules/compute"
  enable_azure        = var.enable_azure && var.enable_compute
  environment         = var.environment
  project_name        = var.project_name
  location            = var.azure_location
  resource_group_name = module.networking.resource_group_name
  subnet_id           = module.networking.private_subnet_id
  tags                = var.tags
  vm_count            = var.vm_count
  vm_size             = var.vm_size
  vm_image            = var.vm_image
  vm_os_disk          = var.vm_os_disk
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  vm_custom_data      = var.vm_custom_data
  depends_on          = [module.networking]
}

module "loadbalancer" {
  source                   = "./modules/loadbalancer"
  enable_azure             = var.enable_azure && var.enable_loadbalancer
  project_name             = var.project_name
  environment              = var.environment
  location                 = var.azure_location
  resource_group_name      = module.networking.resource_group_name
  tags                     = var.tags
  subnet_id                = module.networking.public_subnet_id
  backend_ips              = module.compute.private_ips
  ports                    = var.app_gateway_ports
  probe                    = var.app_gateway_probe
  backend_host             = var.app_gateway_backend_host
  sku                      = var.app_gateway_sku
  ssl_certificate_path     = var.app_gateway_ssl_certificate_path
  ssl_certificate_base64   = var.app_gateway_ssl_certificate_base64
  ssl_certificate_password = var.app_gateway_ssl_certificate_password
  depends_on               = [module.compute]
}

module "nginx_app" {
  source             = "./modules/nginx-app"
  enable_application = var.enable_application
  application_name   = var.application_name
  environment        = var.environment
  project_name       = var.project_name
  lb_dns             = module.loadbalancer.dns_name
}
