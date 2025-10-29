locals {
  tags = merge({
    Environment = var.environment
    Project     = var.project_name
    Component   = "app-gateway"
  }, var.tags)

  certificate_path = var.ssl_certificate_path != "" ? var.ssl_certificate_path : "${path.module}/self-signed-cert.pfx"
  certificate_data = trimspace(var.ssl_certificate_base64) != "" ? var.ssl_certificate_base64 : filebase64(local.certificate_path)
}

resource "azurerm_public_ip" "appgw" {
  count               = var.enable_azure ? 1 : 0
  name                = format("%s-%s-appgw-pip", var.project_name, var.environment)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_application_gateway" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = format("%s-%s-appgw", var.project_name, var.environment)
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = var.ports.http
  }

  frontend_port {
    name = "https-port"
    port = var.ports.https
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw[0].id
  }

  backend_address_pool {
    name         = "backend-pool"
    ip_addresses = var.backend_ips
  }

  backend_http_settings {
    name                                = "https-backend-settings"
    cookie_based_affinity               = "Disabled"
    port                                = var.ports.backend_https
    protocol                            = "Https"
    request_timeout                     = 60
    pick_host_name_from_backend_address = false
    host_name                           = var.backend_host
    probe_name                          = "https-probe"
  }

  probe {
    name                                      = "https-probe"
    protocol                                  = "Https"
    path                                      = var.probe.path
    interval                                  = var.probe.interval
    timeout                                   = var.probe.timeout
    unhealthy_threshold                       = var.probe.unhealthy_threshold
    pick_host_name_from_backend_http_settings = false
    host                                      = var.probe.host
    match {
      status_code = ["200-399"]
    }
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "appgw-ssl-cert"
  }

  ssl_certificate {
    name     = "appgw-ssl-cert"
    data     = local.certificate_data
    password = var.ssl_certificate_password
  }

  redirect_configuration {
    name                 = "http-to-https"
    redirect_type        = "Permanent"
    target_listener_name = "https-listener"
    include_path         = true
    include_query_string = true
  }

  request_routing_rule {
    name                        = "http-redirect-rule"
    rule_type                   = "Basic"
    http_listener_name          = "http-listener"
    redirect_configuration_name = "http-to-https"
    priority                    = 100
  }

  request_routing_rule {
    name                       = "https-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "https-backend-settings"
    priority                   = 101
  }

  tags = local.tags
}
