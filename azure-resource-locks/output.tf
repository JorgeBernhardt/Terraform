// Outputs the created resource locks
output "created_locks" {
  description = "The created resource locks"
  value       = azurerm_management_lock.locks
}
