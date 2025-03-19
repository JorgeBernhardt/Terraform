// Azure Subscription ID
variable "subscription_id" {
  type        = string
  description = "Azure subscription where resources will be deployed."
}

// Azure Region
variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

// Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where resources will be deployed."
}

// Chaos Studio Experiments Configuration
variable "experiments" {
  description = "List of Chaos Studio experiments and their configurations."
  type = list(object({
    name                 = string  // Experiment name
    duration             = string  // Duration (e.g., 'PT5M')
    target_resource_id   = string  // Target Azure resource
    target_resource_type = string  // Resource type (e.g 'Microsoft-AppService')
    role_definition_name = string  // Assigned role
    capability_type      = string  // Chaos Studio capability (e.g., 'Stop-1.0')
    action_type          = string  // Action type (e.g., 'continuous')
    os_type              = optional(string, null) // OS type (if needed)
    parameters           = map(string) // Key-value parameters
  }))
}