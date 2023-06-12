// Output for the created resource group
output "resource_group" {
  description = "The complete resource group object"
  value       = azurerm_resource_group.rg
}

// Output for the created actions groups
output "action_groups" {
  description = "The complete action group objects"
  value       = azurerm_monitor_action_group.ag
}