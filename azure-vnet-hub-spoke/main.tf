/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 13-05-2023
*/

// Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.hub_network.resourceGroupName
  location = var.hub_network.location
  tags     = var.hub_network.tags
}

// Create a hub virtual network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_network.vnetName
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.hub_network.location
  address_space       = [var.hub_network.addressSpace]
  dns_servers         = var.hub_network.dnsServers
  tags                = var.hub_network.tags
}

// Create subnets within the hub virtual network
resource "azurerm_subnet" "hub_subnets" {
  count                = length(var.hub_network.subnetNames)
  name                 = var.hub_network.subnetNames[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.hub_network.subnetPrefixes[count.index]]
}

// Create the spokes virtual networks 
resource "azurerm_virtual_network" "spoke_vnets" {
  count               = length(var.spoke_networks)
  name                = var.spoke_networks[count.index].vnetName
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.spoke_networks[count.index].location
  address_space       = [var.spoke_networks[count.index].addressSpace]
  dns_servers         = var.hub_network.dnsServers
  tags                = var.hub_network.tags
}

// Create a default subnet within each spoke virtual network
resource "azurerm_subnet" "spoke_default_subnets" {
  count                = length(var.spoke_networks)
  name                 = var.spoke_networks[count.index].defaultSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnets[count.index].name
  address_prefixes     = [var.spoke_networks[count.index].defaultSubnetPrefix]
}

// Create a peering connection from the hub to each spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count                     = length(var.spoke_networks)
  name                      = "${var.hub_network.vnetName}-to-${azurerm_virtual_network.spoke_vnets[count.index].name}"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnets[count.index].id
}

// Create a peering connection from each spoke to the hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count                     = length(var.spoke_networks)
  name                      = "${azurerm_virtual_network.spoke_vnets[count.index].name}-to-${var.hub_network.vnetName}"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnets[count.index].name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
}
