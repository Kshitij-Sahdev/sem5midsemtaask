# Multi-Cloud Terraform Deployment

Scalable nginx infrastructure on Azure with SSL termination, modular terraform, and automated CI/CD pipelines. AWS config included but not deployed yet.

## Architecture

**Azure (Active)**
- VNet with isolated public/private subnets
- NAT Gateway for secure outbound access
- Application Gateway (L7 load balancer) with SSL termination
- VMs in private subnet running containerized nginx
- NSG-based security controls

**CI/CD**
- Jenkins pipeline with approval gates
- Azure DevOps multi-stage deployment
- Infrastructure as Code (IaC) with Terraform modules

## Quick Start

```bash
# 1. Setup Azure credentials
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/YOUR_SUB"

# 2. Configure terraform.tfvars with above credentials
# 3. Generate SSL certificate
./generate-cert.sh

# 4. Deploy
terraform init
terraform apply -var-file=environments/dev/terraform.tfvars
```

Access: `https://<output-ip>` (self-signed cert warning is expected)

## Design Decisions

**Why this approach worked:**
- Modular structure = reusable across environments
- Private VMs + NAT = security without complexity
- Cloud-init = no manual VM configuration needed
- App Gateway handles SSL = offload from backend
- Self-signed certs = faster dev iteration

**Shortcuts that saved time:**
- Local state (remote backend is TODO)
- Single VM for dev (scale later)
- Cloud-init builds container on boot (no registry needed)
- Self-signed certs (proper CA certs for prod)

## Prerequisites

- Azure subscription with contributor access
- Terraform 1.3+
- Docker (for local testing)
- OpenSSL (cert generation)
- SSH keypair

## Module Structure

```
modules/
├── networking/    # VNet, subnets, NAT, NSG
├── compute/       # VMs with cloud-init
├── loadbalancer/  # App Gateway config
└── nginx-app/     # Application layer
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Cert not found | Run `./generate-cert.sh` first |
| App Gateway timeout | Normal - takes 10-15min to provision |
| Can't SSH to VM | VMs have no public IP - use Azure Bastion |
| Health probe failing | Wait 2-3min for nginx to start |

## Cost (~$180/month if running 24/7)

- VM (Standard_B1s): $7
- App Gateway (Standard_v2): $140
- NAT Gateway: $33

**Tip:** `terraform destroy` when not using

## Roadmap

- [ ] Remote state backend (Azure Storage)
- [ ] AWS deployment with cross-cloud routing
- [ ] Let's Encrypt SSL automation
- [ ] Auto-scaling policies
- [ ] Monitoring & alerting
