/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 30-08-2023
*/

// Create Azure Log Analytics Workspaces based on settings in var.log_analytics_workspace_settings
resource "azurerm_log_analytics_workspace" "law" {
  for_each = { for idx, settings in var.log_analytics_workspace_settings : idx => settings }

  // Basic Information
  name                = each.value.name 
  resource_group_name = each.value.resource_group_name  
  location            = each.value.location  
  sku                 = each.value.sku  

  // Data Retention and Quotas
  retention_in_days = each.value.retention_in_days  // Data retention period in days
  daily_quota_gb    = each.value.daily_quota_gb  // Daily data ingestion quota in GB

  // Permissions and Authentication
  allow_resource_only_permissions = each.value.allow_resource_only_permissions  
  local_authentication_disabled   = each.value.local_authentication_disabled  

  // Data Ingestion and Query Settings
  internet_ingestion_enabled = each.value.internet_ingestion_enabled 
  internet_query_enabled     = each.value.internet_query_enabled 
  
  // Customer Managed Key for Query
  cmk_for_query_forced       = each.value.cmk_for_query_forced 

  // Common Tags
  tags = var.tags  // Apply common tags
}
