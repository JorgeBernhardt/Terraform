// Output IDs of Log Analytics Workspace
output "log_analytics_workspace_ids" {
  value       = { for idx, law in azurerm_log_analytics_workspace.law : idx => law.id }
  description = "IDs of Log Analytics Workspace"
}

// Output Primary Keys of Log Analytics Workspace (Sensitive)
output "log_analytics_workspace_primary_keys" {
  value       = { for idx, law in azurerm_log_analytics_workspace.law : idx => law.primary_shared_key }
  description = "Primary Shared Keys of Log Analytics Workspace"
  sensitive   = true  // Mark as sensitive
}

// Output Secondary Keys of Log Analytics Workspace (Sensitive)
output "log_analytics_workspace_secondary_keys" {
  value       = { for idx, law in azurerm_log_analytics_workspace.law : idx => law.secondary_shared_key }
  description = "Secondary Shared Keys of Log Analytics Workspace"
  sensitive   = true  // Mark as sensitive
}
