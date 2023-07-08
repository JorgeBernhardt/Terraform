// Output for the Public IP Address
output "public_ip_address" {
  description = "The Public IP Address"
  value       = azurerm_public_ip.public_ip.ip_address
}

// Output for the Azure Bastion Host
output "bastion_host_location" {
  description = "The Location of the Azure Bastion Host"
  value       = azurerm_bastion_host.bastion_host.location
}

// Output for the Azure Bastion Host
output "bastion_host_id" {
  description = "The ID of the Azure Bastion Host"
  value       = azurerm_bastion_host.bastion_host.id
}

// Output for the Azure Bastion Host Name
output "bastion_host_name" {
  description = "The Name of the Azure Bastion Host"
  value       = azurerm_bastion_host.bastion_host.name
}
