// Output for the created resource group
output "resource_group" {
  description = "The created resource group"
  value       = azurerm_resource_group.rg
}

// Output for the created private DNS zones
output "private_dns_zones" {
  description = "The created private DNS zones"
  value       = [for zone in azurerm_private_dns_zone.priv_dns_zone : zone]
}

// Output for the created private DNS A records
output "private_dns_a_records" {
  description = "Information about the DNS A records that were created"
  value       = { for rec in azurerm_private_dns_a_record.dns_a_record : "${rec.zone_name}-${rec.name}" => rec }
}

