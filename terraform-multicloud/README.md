# Terraform Multi-Cloud Infra

## Features
- AWS + Azure hybrid infrastructure
- Modular Terraform setup
- Dockerized NGINX with SSL
- CI/CD using Jenkins & Azure Pipelines

## Usage
1. Configure your credentials in `terraform.tfvars`.
2. Build Docker image locally.
3. Run:
   terraform init
   terraform apply -var-file=environments/dev/terraform.tfvars
