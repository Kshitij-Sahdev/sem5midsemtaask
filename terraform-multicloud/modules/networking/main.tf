locals {
  tags = merge({
    Environment = var.environment
    Project     = var.project_name
  }, var.tags)

  resource_group_name = trimspace(var.resource_group_name) != "" ? var.resource_group_name : "${var.project_name}-${var.environment}-rg"

  public_subnets  = { for idx, prefix in var.public_subnet_prefixes : format("%02d", idx) => prefix }
  private_subnets = { for idx, prefix in var.private_subnet_prefixes : format("%02d", idx) => prefix }
}

resource "azurerm_resource_group" "main" {
  count    = var.enable_azure ? 1 : 0
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

resource "azurerm_subnet" "public" {
  for_each             = var.enable_azure ? local.public_subnets : {}
  name                 = "${var.environment}-public-${each.key}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "private" {
  for_each             = var.enable_azure ? local.private_subnets : {}
  name                 = "${var.environment}-private-${each.key}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [each.value]
}

resource "azurerm_public_ip" "nat" {
  for_each = var.enable_azure && var.nat_gateway_enabled ? { default = true } : {}

  name                = "${var.environment}-nat-pip"
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_nat_gateway" "main" {
  for_each = var.enable_azure && var.nat_gateway_enabled ? { default = true } : {}

  name                = "${var.environment}-nat-gateway"
  location            = var.location
  resource_group_name = local.resource_group_name
  sku_name            = "Standard"
  tags                = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  for_each = var.enable_azure && var.nat_gateway_enabled ? azurerm_nat_gateway.main : {}

  nat_gateway_id       = each.value.id
  public_ip_address_id = azurerm_public_ip.nat[each.key].id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  for_each = var.enable_azure && var.nat_gateway_enabled ? azurerm_subnet.private : {}

  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.main["default"].id
}

resource "azurerm_network_security_group" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.environment}-nsg"
  location            = var.location
  resource_group_name = local.resource_group_name

  dynamic "security_rule" {
    for_each = { for idx, port in var.allowed_inbound_ports : format("%02d", idx) => port }
    content {
      name                       = "allow-tcp-${security_rule.value}"
      priority                   = 1000 + tonumber(security_rule.key)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value)
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "private" {
  for_each = var.enable_azure ? azurerm_subnet.private : {}

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.main[0].id
}
