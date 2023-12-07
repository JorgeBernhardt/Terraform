/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 06-12-2023
*/
locals {
  // Create a map to determine if each namespace's SKU is 'Premium'
  is_premium_sku = { for k, v in var.namespaces : k => v.sku == "Premium" }
}

resource "azurerm_servicebus_namespace" "namespace" {
  // Iterate over each namespace defined in var.namespaces
  for_each            = var.namespaces
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  // General attributes for all SKUs
  local_auth_enabled            = each.value.local_auth_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  minimum_tls_version           = each.value.minimum_tls_version
  tags                          = var.tags

  // Attributes and configurations specific to 'Premium' SKU
  capacity                      = local.is_premium_sku[each.key] ? each.value.capacity : null
  zone_redundant                = local.is_premium_sku[each.key] ? each.value.zone_redundant : null

  // Dynamic block for identity - conditionally created for 'Premium' SKU
  dynamic "identity" {
    for_each = local.is_premium_sku[each.key] && can(each.value.identity) && try(length(each.value.identity) > 0, false) ? [each.value.identity] : []
    content {
      type = identity.value.type
      identity_ids = identity.value.type == "UserAssigned" ? identity.value.identity_ids : null
    }
  }

  // Dynamic block for customer managed key - only for 'Premium' SKU
  dynamic "customer_managed_key" {
    for_each = local.is_premium_sku[each.key] && can(each.value.customer_managed_key) && try(length(each.value.customer_managed_key) > 0, false) ? [each.value.customer_managed_key] : []
    content {
      key_vault_key_id                  = customer_managed_key.value.key_vault_key_id
      identity_id                       = customer_managed_key.value.identity_id
      infrastructure_encryption_enabled = customer_managed_key.value.infrastructure_encryption_enabled
    }
  }

  // Dynamic block for network rule set - applies only to 'Premium' SKU
  dynamic "network_rule_set" {
    for_each = local.is_premium_sku[each.key] && can(each.value.network_rule_set) && try(length(each.value.network_rule_set) > 0, false) ? [each.value.network_rule_set] : []
    content {
      default_action = network_rule_set.value.default_action
      ip_rules       = network_rule_set.value.ip_rules
      trusted_services_allowed = lookup(network_rule_set.value, "trusted_services_allowed", true)
    }
  }
}
