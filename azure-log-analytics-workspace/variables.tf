// Variables for Log Analytics Workspace Settings
variable "log_analytics_workspace_settings" {
  type = list(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    sku                             = string
    retention_in_days               = optional(number)
    daily_quota_gb                  = optional(number)
    allow_resource_only_permissions = optional(bool)
    local_authentication_disabled   = optional(bool)
    internet_ingestion_enabled      = optional(bool)
    internet_query_enabled          = optional(bool)
    cmk_for_query_forced            = optional(bool)
  }))

  // Validation for retention period in days
  validation {
    condition = alltrue([
      for law in var.log_analytics_workspace_settings : (
        law.retention_in_days == 7 || (law.retention_in_days >= 30 && law.retention_in_days <= 730)
      )
    ])
    error_message = "Retention period must be 7 (Free Tier only) or a range between 30 and 730."
  }

  // Validation for SKU
  validation {
    condition = alltrue([
      for law in var.log_analytics_workspace_settings : law.sku == "PerGB2018"
    ])
    error_message = "The only valid value for SKU is PerGB2018."
  }

  // Validation for location
  validation {
    condition = alltrue([
      for law in var.log_analytics_workspace_settings : contains([
        "West Europe",
        "North Europe",
      ], law.location)
    ])
    error_message = "Valid locations are West Europe and North Europe."
  }
}

// Common tags for all Azure resources created
variable "tags" {
  description = "Common tags for all resources"
  
  # Define the type structure for the tags
  type = object({
    Environment = string
    Terraform   = string
  })

  # Default values for tags
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}
