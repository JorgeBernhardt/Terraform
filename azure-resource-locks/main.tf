// Get the current Azure subscription details
data "azurerm_subscription" "current" {
}

// Looping over the input map to create management locks
resource "azurerm_management_lock" "locks" {
  for_each = { for k, v in var.lock_info : v.index => v }

  name       = each.value.name
  lock_level = each.value.lock_level // The lock level - CanNotDelete or ReadOnly
  notes      = each.value.notes

  scope = try("subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/${each.value.resource_type}/${each.value.resource_name}",
    try("subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.value.resource_group_name}",
      data.azurerm_subscription.current.id
    )
  )
}
