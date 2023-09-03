// Output Resource Group Names
output "rg_names" {
  value = {
    for settings in local.rg_required_settings :
    settings.name => azurerm_resource_group.rg["${settings.resource_group_name}-${settings.name}"].name
  }
  description = "The names of the created or managed Azure Resource Groups."
}

// Output Application Insights Instrumentation Keys
output "appi_instrumentation_keys" {
  value = {
    for settings in var.application_insights_settings :
    settings.name => azurerm_application_insights.appi["${settings.resource_group_name}-${settings.name}"].instrumentation_key
  }
  description = "The Instrumentation Keys for the Application Insights resources."
  sensitive   = true  // Mark the output as sensitive data
}

// Output Application Insights App IDs
output "appi_ids" {
  value = {
    for settings in var.application_insights_settings :
    settings.name => azurerm_application_insights.appi["${settings.resource_group_name}-${settings.name}"].app_id
  }
  description = "The App IDs for the Application Insights resources."
}
