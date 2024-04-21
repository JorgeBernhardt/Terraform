// Output the Container Registry IDs
output "container_registry_ids" {
  description = "The IDs of the Azure Container Registries."
  value       = { for acr in azurerm_container_registry.acr : acr.name => acr.id }
  sensitive   = false
}