/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 13-05-2023
*/

// Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

// Private DNS zones
resource "azurerm_private_dns_zone" "priv_dns_zone" {
  for_each = { for zone in var.dns_zones : zone.zone_name => zone }

  name                = each.value.zone_name
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

// DNS A records
resource "azurerm_private_dns_a_record" "dns_a_record" {
  for_each = { for rec in var.dns_records : "${rec.zone_name}-${rec.record_name}" => rec }

  name                = each.value.record_name
  zone_name           = each.value.zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = each.value.ttl
  records             = [each.value.ip]
  tags                = var.tags
  depends_on          = [azurerm_private_dns_zone.priv_dns_zone]

}
