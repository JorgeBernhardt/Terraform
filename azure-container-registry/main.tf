/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 20-04-2024
*/

// Define a resource for Azure Container Registry
resource "azurerm_container_registry" "acr" {
  for_each = var.acr_config // Iterate over each ACR configuration provided

  name                          = each.value.name // Set the name of the ACR
  location                      = each.value.location // Set the location for the ACR
  resource_group_name           = each.value.resource_group_name // Set the resource group for the ACR
  sku                           = each.value.sku // Set the SKU for the ACR
  admin_enabled                 = each.value.admin_enabled // Enable or disable admin user
  public_network_access_enabled = each.value.public_network_access_enabled // Enable or disable public network access

  // Conditionally apply network rules if SKU is Premium and public access is disabled
  dynamic "network_rule_set" {
    for_each = each.value.sku == "Premium" && !each.value.public_network_access_enabled ? [1] : []
    content {
      default_action = "Deny" // Default action to deny all unless specified

      // Define IP rules for allowed IPs
      dynamic "ip_rule" {
        for_each = each.value.ip_rules 
        content {
          action   = "Allow" 
          ip_range = ip_rule.value 
        }
      }
    }
  }

  // Setup identity management for the ACR
  dynamic "identity" {
    for_each = each.value.identity_type != "" ? [1] : []
    content {
      type = each.value.identity_type 

      // Add specific user assigned identity IDs if applicable
      identity_ids = (each.value.identity_type == "UserAssigned" || each.value.identity_type == "SystemAssigned, UserAssigned") && each.value.user_assigned_identity_id != null ? [each.value.user_assigned_identity_id] : []
    }
  }

  quarantine_policy_enabled = each.value.quarantine_policy_enabled 

  // Configure retention policy for untagged manifests
  retention_policy {
    days    = each.value.retention_days // Number of days to retain the untagged manifests
    enabled = each.value.retention_days > 0 // Enable retention policy if days are greater than 0
  }

  // Setup georeplication for the ACR if SKU is Premium
  dynamic "georeplications" {
    for_each = each.value.sku == "Premium" ? each.value.georeplications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled 
      tags                    = georeplications.value.tags 
    }
  }
}
