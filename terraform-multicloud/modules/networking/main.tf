resource "azurerm_resource_group" "main" {
  count    = var.enable_azure ? 1 : 0
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = { Environment = var.environment }
}

resource "azurerm_virtual_network" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main[0].name
  tags                = { Environment = var.environment }
}

resource "azurerm_subnet" "public" {
  count                = var.enable_azure ? 1 : 0
  name                 = "${var.environment}-public-subnet"
  resource_group_name  = azurerm_resource_group.main[0].name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  count                = var.enable_azure ? 1 : 0
  name                 = "${var.environment}-private-subnet"
  resource_group_name  = azurerm_resource_group.main[0].name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "nat" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.environment}-nat-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = { Environment = var.environment }
}

resource "azurerm_nat_gateway" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.environment}-nat-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.main[0].name
  sku_name            = "Standard"
  tags                = { Environment = var.environment }
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                = var.enable_azure ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = var.enable_azure ? 1 : 0
  subnet_id      = azurerm_subnet.private[0].id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_network_security_group" "main" {
  count               = var.enable_azure ? 1 : 0
  name                = "${var.environment}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main[0].name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"  # TODO: restrict
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = { Environment = var.environment }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.enable_azure ? 1 : 0
  subnet_id                 = azurerm_subnet.private[0].id
  network_security_group_id = azurerm_network_security_group.main[0].id
}
