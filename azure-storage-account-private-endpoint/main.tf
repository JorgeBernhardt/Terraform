/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 08-10-2023
*/
# Using locals to define a mapping of service domains for easy reference.
locals {
  service_domains = {
    blob  = "privatelink.blob.core.windows.net",
    table = "privatelink.table.core.windows.net",
    queue = "privatelink.queue.core.windows.net",
    file  = "privatelink.file.core.windows.net"
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

# Create private DNS zones based on the service domains.
resource "azurerm_private_dns_zone" "pdnszone" {
  for_each            = var.private_endpoints
  name                = local.service_domains[each.value.private_service_subresource_name]
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
    subresource_names              = [each.value.private_service_subresource_name]
  }

  # Link private endpoints to the respective DNS zones.
  private_dns_zone_group {
    name                 = "pdnszgroup-${each.key}"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdnszone[each.key].id]
  }

  tags = each.value.tags
}

# Create A records in private DNS zones for the private endpoints.
resource "azurerm_private_dns_a_record" "pdnsrecord" {
  for_each            = var.private_endpoints
  name                = "pep-${each.key}"
  resource_group_name = each.value.resource_group_name
  zone_name           = azurerm_private_dns_zone.pdnszone[each.key].name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pep[each.key].private_service_connection[0].private_ip_address]
  tags                = each.value.tags
}
