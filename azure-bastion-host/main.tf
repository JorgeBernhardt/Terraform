/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 08-07-2023
*/

// Get the details of an existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group.name
}

// Get the details of an existing virtual network
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

// Creating a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet.address_prefixes
}

// Creating a Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = var.public_ip.allocation_method
  sku                 = var.public_ip.sku
  tags                = var.tags
}

// Creating an Azure Bastion Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.bastion_host.sku

  // Setting the optional Bastion host settings based on SKU type
  copy_paste_enabled     = var.bastion_host.sku == "Standard" ? var.bastion_host.copy_paste_enabled : null
  file_copy_enabled      = var.bastion_host.sku == "Standard" ? var.bastion_host.file_copy_enabled : null
  ip_connect_enabled     = var.bastion_host.sku == "Standard" ? var.bastion_host.ip_connect_enabled : null
  scale_units            = var.bastion_host.sku == "Standard" ? var.bastion_host.scale_units : null
  shareable_link_enabled = var.bastion_host.sku == "Standard" ? var.bastion_host.shareable_link_enabled : null
  tunneling_enabled      = var.bastion_host.sku == "Standard" ? var.bastion_host.tunneling_enabled : null

  // Configuring IP settings for the Bastion host
  ip_configuration {
    name                 = var.bastion_host.ip_configuration.name
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  // Adding tags to the Bastion host
  tags = var.tags
}

