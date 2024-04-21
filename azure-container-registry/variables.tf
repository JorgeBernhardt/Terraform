// Variables for Azcure Container Registries Settings
variable "acr_config" {
  description = "Configuración de los Azure Container Registries"
  type = map(object({
    name                          = string
    location                      = string
    sku                           = string
    resource_group_name           = string
    admin_enabled                 = bool
    public_network_access_enabled = bool
    ip_rules                      = list(string)
    identity_type                 = string           
    user_assigned_identity_id     = optional(string) 
    quarantine_policy_enabled     = bool
    retention_days                = number
    georeplications = list(object({
      location                = string
      zone_redundancy_enabled = bool
      tags                    = map(string)
    }))
  }))

  // Validation for identity_type
  validation {
    condition = alltrue([
      for acr in var.acr_config : contains(["SystemAssigned", "UserAssigned"], acr.identity_type)
    ])
    error_message = "Each ACR configuration must have 'identity_type' set to either 'SystemAssigned' or 'UserAssigned'."
  }
}

// Variable for tags
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}