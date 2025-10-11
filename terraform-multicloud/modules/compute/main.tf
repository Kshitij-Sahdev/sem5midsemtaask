resource "azurerm_network_interface" "nginx_nic" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.environment}-nginx-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { Environment = var.environment }
}

resource "azurerm_linux_virtual_machine" "nginx_vm" {
  count                           = var.enable_azure ? 1 : 0
  name                            = "${var.environment}-nginx-vm-${count.index}"
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
    name                 = "${var.environment}-nginx-osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    
    cat > /tmp/Dockerfile <<'DOCKEREOF'
FROM nginx:alpine
RUN apk add --no-cache openssl && mkdir -p /etc/nginx/certs
WORKDIR /etc/nginx/certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/CN=localhost"
RUN echo 'server { listen 80; return 301 https://\$host\$request_uri; } server { listen 443 ssl; ssl_certificate /etc/nginx/certs/cert.pem; ssl_certificate_key /etc/nginx/certs/key.pem; location / { root /usr/share/nginx/html; index index.html; } location /health { access_log off; return 200 "healthy\n"; } }' > /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
DOCKEREOF
    
    docker build -t nginx-ssl /tmp/
    docker run -d -p 80:80 -p 443:443 --name nginx --restart unless-stopped nginx-ssl
  EOF
  )

  tags = { Environment = var.environment, Role = "nginx" }
}
