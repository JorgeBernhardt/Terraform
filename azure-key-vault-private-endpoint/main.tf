/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 20-10-2023
*/

# Using locals to define a mapping of service domains for easy reference.
locals {
  service_domains = {
    keyvault = "privatelink.vaultcore.azure.net"
  }
}

# Fetch details of the existing resource group where private endpoints will be created.
data "azurerm_resource_group" "existing" {
  for_each = var.private_endpoints
  name     = each.value.resource_group_name
}

# Fetch details of the existing virtual network where private endpoints will connect.
data "azurerm_virtual_network" "existing" {
  for_each            = var.private_endpoints
  name                = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}

# Fetch details of the subnet where private endpoints will reside.
data "azurerm_subnet" "existing" {
  for_each             = var.private_endpoints
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_private_dns_a_record" "records" {
  for_each = var.private_endpoints # Usa var.private_endpoints como iterador
  name                = split("/", each.value.resource_id_to_link)[length(split("/", each.value.resource_id_to_link)) - 1]
  resource_group_name = each.value.resource_group_name
  zone_name           = local.service_domains["keyvault"]

  depends_on = [azurerm_private_endpoint.pep]
}

# Create private DNS zones based on the service domains.
resource "azurerm_private_dns_zone" "pdnszone" {
  for_each            = var.private_endpoints
  name                = local.service_domains["keyvault"]
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}

# Establish the link between private DNS zones and the virtual network.
resource "azurerm_private_dns_zone_virtual_network_link" "pdnszlink" {
  for_each              = var.private_endpoints
  name                  = "link-${each.key}"
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdnszone[each.key].name
  virtual_network_id    = data.azurerm_virtual_network.existing[each.key].id
  tags                  = each.value.tags
}

# Create private endpoints in the specified subnets and connect to the target resources.
resource "azurerm_private_endpoint" "pep" {
  for_each            = var.private_endpoints
  name                = "pep-${each.key}"
  location            = data.azurerm_resource_group.existing[each.key].location
  resource_group_name = each.value.resource_group_name
  subnet_id           = data.azurerm_subnet.existing[each.key].id

  private_service_connection {
    name                           = "connection-${each.key}"
    is_manual_connection           = false
    private_connection_resource_id = each.value.resource_id_to_link
    subresource_names              = ["vault"]

  }

  # Link private endpoints to the respective DNS zones.
  private_dns_zone_group {
    name                 = "pdnszgroup-${each.key}"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdnszone[each.key].id]
  }

  tags = each.value.tags
}
