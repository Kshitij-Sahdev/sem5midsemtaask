locals {
  tags = merge({
    Environment = var.environment
    Project     = var.project_name
    Role        = "nginx"
  }, var.tags)

  default_custom_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    apt-get update
    apt-get install -y docker.io
    systemctl enable --now docker

    cat > /tmp/Dockerfile <<'DOCKEREOF'
    FROM nginx:alpine
    RUN apk add --no-cache openssl && mkdir -p /etc/nginx/certs
    WORKDIR /etc/nginx/certs
    RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/CN=localhost"
    RUN echo 'server { listen 80; return 301 https://$host$request_uri; } server { listen 443 ssl; ssl_certificate /etc/nginx/certs/cert.pem; ssl_certificate_key /etc/nginx/certs/key.pem; location / { root /usr/share/nginx/html; index index.html; } location /health { access_log off; return 200 "healthy\\n"; } }' > /etc/nginx/conf.d/default.conf
    EXPOSE 80 443
    CMD ["nginx", "-g", "daemon off;"]
    DOCKEREOF

    docker build -t nginx-ssl /tmp/
    docker run -d -p 80:80 -p 443:443 --name nginx --restart unless-stopped nginx-ssl || \
      docker restart nginx
  EOF

  custom_data_payload = trimspace(var.vm_custom_data) != "" ? var.vm_custom_data : local.default_custom_data
}

resource "azurerm_network_interface" "nginx_nic" {
  count               = var.enable_azure ? var.vm_count : 0
  name                = format("%s-%s-nic-%02d", var.project_name, var.environment, count.index)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "nginx_vm" {
  count                           = var.enable_azure ? var.vm_count : 0
  name                            = format("%s-%s-vm-%02d", var.project_name, var.environment, count.index)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.nginx_nic[count.index].id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = format("%s-%s-osdisk-%02d", var.project_name, var.environment, count.index)
    caching              = var.vm_os_disk.caching
    storage_account_type = var.vm_os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }

  custom_data = base64encode(local.custom_data_payload)

  tags = local.tags
}
