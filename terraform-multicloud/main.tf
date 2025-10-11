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
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

module "networking" {
  source       = "./modules/networking"
  environment  = var.environment
  location     = var.azure_location
  project_name = var.project_name
  enable_azure = var.enable_azure
}

module "compute" {
  source              = "./modules/compute"
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = module.networking.resource_group_name
  subnet_id           = module.networking.private_subnet_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  enable_azure        = var.enable_azure
  depends_on          = [module.networking]
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = module.networking.resource_group_name
  backend_ips         = module.compute.private_ips
  subnet_id           = module.networking.public_subnet_id
  enable_azure        = var.enable_azure
  depends_on          = [module.compute]
}

module "nginx_app" {
  source     = "./modules/nginx-app"
  lb_dns     = module.loadbalancer.dns_name
  depends_on = [module.loadbalancer]
}
