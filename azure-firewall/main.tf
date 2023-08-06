/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 06-08-2023
*/

locals {
  rg_name = var.resource_group.name
}

// Fetching the details of an existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = local.rg_name
}

// Fetching the details of an existing Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  resource_group_name = local.rg_name
}

// Creating a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = local.rg_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet.address_prefixes
}

// Creating a Public IP Address for Firewall
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = local.rg_name
  allocation_method   = var.public_ip.allocation_method
  sku                 = var.public_ip.sku
}

// Creating an Azure Firewall
resource "azurerm_firewall" "firewall" {
  name                = var.firewall.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = local.rg_name

  // SKU configuration
  sku_name = var.firewall.sku_name
  sku_tier = var.firewall.sku_tier

  ip_configuration {
    name                 = var.firewall.ip_configuration.name
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  // Adding tags to the Firewall
  tags = var.tags
}
