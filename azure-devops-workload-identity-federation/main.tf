/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 17-05-2025
*/
// Retrieves existing Azure Resource Groups by name
data "azurerm_resource_group" "rg" {
  for_each = { for i in var.federated_identities : i.name => i }
  name     = each.value.resource_group_name
}

// Looks up existing Azure DevOps projects if create_project is false
data "azuredevops_project" "existing_projects" {
  for_each = { for i in var.federated_identities : i.name => i if !i.create_project }
  name     = each.value.devops_project_name
}

// Creates a User Assigned Managed Identity in the specified resource group
resource "azurerm_user_assigned_identity" "federated" {
  for_each            = { for i in var.federated_identities : i.name => i }
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

// Creates a new Azure DevOps project if create_project is true
resource "azuredevops_project" "projects" {
  for_each           = { for i in var.federated_identities : i.name => i if i.create_project }
  name               = each.value.devops_project_name
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "Managed by Terraform"
}

// Creates a federated service connection in Azure DevOps using a managed identity
resource "azuredevops_serviceendpoint_azurerm" "connections" {
  for_each = { for i in var.federated_identities : i.service_connection => i }

  project_id = try(
    azuredevops_project.projects[each.value.name].id,
    data.azuredevops_project.existing_projects[each.value.name].id
  )

  service_endpoint_name                  = each.value.service_connection
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.federated[each.value.name].client_id
  }

  azurerm_spn_tenantid      = each.value.tenant_id
  azurerm_subscription_id   = each.value.subscription_id
  azurerm_subscription_name = each.value.subscription_name
}
// Defines the federated credential in Microsoft Entra ID for use with Workload Identity Federation (OIDC-based)
resource "azurerm_federated_identity_credential" "creds" {
  for_each            = { for i in var.federated_identities : i.name => i }
  name                = "fid-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  parent_id           = azurerm_user_assigned_identity.federated[each.value.name].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azuredevops_serviceendpoint_azurerm.connections[each.value.service_connection].workload_identity_federation_issuer
  subject             = "sc://${each.value.org_name}/${each.value.devops_project_name}/${each.value.service_connection}"

}

// Assigns the specified role to the managed identity over the resource group
resource "azurerm_role_assignment" "identity_rg_access" {
  for_each = { for i in var.federated_identities : i.name => i }

  scope                = data.azurerm_resource_group.rg[each.key].id
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.federated[each.key].principal_id

  depends_on = [
    azurerm_user_assigned_identity.federated
  ]
}