// User Assigned Identity
resource "azurerm_user_assigned_identity" "identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "chaosstudio-identity"
}

// Role Assignment for Chaos Studio Identity
resource "azurerm_role_assignment" "chaos_studio_identity_role_assignment" {
  for_each             = { for exp in var.experiments : exp.name => exp } 
  scope                = each.value.target_resource_id
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.identity.principal_id

  depends_on = [azurerm_chaos_studio_experiment.experiment]
}

// Chaos Studio Experiment
resource "azurerm_chaos_studio_experiment" "experiment" {
  for_each            = { for exp in var.experiments : exp.name => exp }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  selectors {
    name                    = "Selector-${each.key}"
    chaos_studio_target_ids = [azurerm_chaos_studio_target.target[each.key].id]
  }

  steps {
    name = "step-${each.key}"
    branch {
      name = "branch-${each.key}"
      actions {
        urn           = azurerm_chaos_studio_capability.capability[each.key].urn
        selector_name = "Selector-${each.key}"
        parameters    = each.value.parameters
        action_type   = each.value.action_type
        duration      = each.value.duration
      }
    }
  }
}

// Chaos Studio Target
resource "azurerm_chaos_studio_target" "target" {
  for_each           = { for exp in var.experiments : exp.name => exp }
  location           = var.location
  target_resource_id = each.value.target_resource_id
  target_type        = each.value.target_resource_type
}

// Chaos Studio Capability
resource "azurerm_chaos_studio_capability" "capability" {
  for_each               = { for exp in var.experiments : exp.name => exp }
  capability_type        = each.value.capability_type
  chaos_studio_target_id = azurerm_chaos_studio_target.target[each.key].id
}
