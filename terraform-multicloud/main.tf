terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws   = { source = "hashicorp/aws", version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }

  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  skip_credentials_validation = true
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

module "networking" {
  source = "./modules/networking"
  enable_aws   = var.enable_aws
  enable_azure = var.enable_azure
}

module "compute" {
  source = "./modules/compute"
  vpc_id      = module.networking.vpc_id
  subnet_id   = module.networking.subnet_id
  enable_aws   = var.enable_aws
  enable_azure = var.enable_azure
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  target_ips = module.compute.private_ips
  enable_aws   = var.enable_aws
  enable_azure = var.enable_azure
}

module "nginx_app" {
  source = "./modules/nginx-app"
  lb_dns = module.loadbalancer.dns_name
}
