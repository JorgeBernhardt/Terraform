/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 03-09-2023
*/

// Locals block to filter out settings that require a new resource group
locals {
  // Extract settings that require a new resource group
  rg_required_settings = [for setting in var.application_insights_settings : setting if setting.require_new_resource_group]
}

// Create Resource Groups based on filtered settings
resource "azurerm_resource_group" "rg" {
  for_each = { for setting in local.rg_required_settings : "${setting.resource_group_name}-${setting.name}" => setting }

  location = each.value.resource_group_location
  name     = each.value.resource_group_name

  tags = var.tags
}

// Create Application Insights resources
resource "azurerm_application_insights" "appi" {
  for_each = { for setting in var.application_insights_settings : "${setting.resource_group_name}-${setting.name}" => setting }

  application_type                      = each.value.application_type
  daily_data_cap_in_gb                  = each.value.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = each.value.daily_data_cap_notifications_disabled
  disable_ip_masking                    = each.value.disable_ip_masking
  force_customer_storage_for_profiler   = each.value.force_customer_storage_for_profiler
  internet_ingestion_enabled            = each.value.internet_ingestion_enabled
  internet_query_enabled                = each.value.internet_query_enabled
  local_authentication_disabled         = each.value.local_authentication_disabled
  location                              = each.value.resource_group_location
  name                                  = each.value.name
  retention_in_days                     = each.value.retention_in_days
  resource_group_name                   = each.value.resource_group_name
  sampling_percentage                   = each.value.sampling_percentage
  workspace_id                          = each.value.workspace_id

  tags = var.tags

  depends_on = [
    azurerm_resource_group.rg
  ]
}
