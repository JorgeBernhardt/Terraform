// Azure Subscription ID where resources will be deployed
variable "subscription_id" {
  type        = string
  description = "Azure subscription where resources will be deployed."
  sensitive   = true
}

// Azure DevOps organization URL
variable "azure_devops_org_url" {
  type        = string
  description = "URL of the Azure DevOps organization"
}

// Azure DevOps Personal Access Token used for authentication
variable "azure_devops_pat" {
  type        = string
  description = "Personal Access Token for Azure DevOps authentication."
  sensitive   = true
}

// Federated identity configurations for linking Azure DevOps and Azure AD
variable "federated_identities" {
  description = "List of federated identity configurations for Azure DevOps service connections."
  type = list(object({
    name                 = string // Unique name for the identity
    location             = string // Azure region where the identity will be created
    resource_group_name  = string // Resource group where the identity will reside
    devops_project_name  = string // Name of the Azure DevOps project
    service_connection   = string // Name of the Azure DevOps service connection
    tenant_id            = string // Azure AD tenant ID
    subscription_id      = string // Azure subscription ID used by the service connection
    subscription_name    = string // Display name of the Azure subscription
    org_name             = string // Azure DevOps organization name
    role_definition_name = string // Role to assign to the identity (e.g., Contributor, Reader)
    create_project       = bool   // Whether to create the Azure DevOps project or use an existing one
  }))
}
