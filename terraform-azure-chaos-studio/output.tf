// Output for User Assigned Identity
output "user_assigned_identity" {
  description = "Details of the User Assigned Identity."
  value = {
    id           = azurerm_user_assigned_identity.identity.id
    principal_id = azurerm_user_assigned_identity.identity.principal_id
  }
}

// Output for Chaos Studio Role Assignments
output "chaos_studio_role_assignments" {
  description = "The role assignments for the Chaos Studio identity."
  value = {
    for k, v in azurerm_role_assignment.chaos_studio_identity_role_assignment :
    k => {
      id           = v.id
      scope        = v.scope
      principal_id = v.principal_id
      role_name    = v.role_definition_name
    }
  }
}

// Output for Chaos Studio Targets
output "chaos_studio_targets" {
  description = "The Chaos Studio targets created."
  value = {
    for k, v in azurerm_chaos_studio_target.target :
    k => {
      id              = v.id
      target_resource = v.target_resource_id
      target_type     = v.target_type
    }
  }
}

// Output for Chaos Studio Capabilities
output "chaos_studio_capabilities" {
  description = "The Chaos Studio capabilities created."
  value = {
    for k, v in azurerm_chaos_studio_capability.capability :
    k => {
      id              = v.id
      capability_type = v.capability_type
      target_id       = v.chaos_studio_target_id
    }
  }
}

// Output for Chaos Studio Experiments
output "chaos_studio_experiments" {
  description = "The Chaos Studio experiments created."
  value = {
    for k, v in azurerm_chaos_studio_experiment.experiment :
    k => {
      id                  = v.id
      name                = v.name
      identity_principal  = v.identity[0].principal_id
      resource_group_name = v.resource_group_name
      selectors           = v.selectors
      steps               = v.steps
    }
  }
}