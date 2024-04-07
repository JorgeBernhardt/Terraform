// Application Insights Settings
variable "application_insights_settings" {
  description = "List of settings for Application Insights instances"

  // Define the expected object structure
  type = list(object({
    name                                  = string
    require_new_resource_group            = bool
    resource_group_name                   = string
    resource_group_location               = string
    application_type                      = string
    daily_data_cap_in_gb                  = number
    daily_data_cap_notifications_disabled = bool
    retention_in_days                     = number
    sampling_percentage                   = number
    disable_ip_masking                    = bool
    workspace_id                          = string
    local_authentication_disabled         = bool
    internet_ingestion_enabled            = bool
    internet_query_enabled                = bool
    force_customer_storage_for_profiler   = bool
  }))

  // Validation for application type
  validation {
    condition = alltrue([
      for s in var.application_insights_settings : s.application_type == "web"
    ])
    error_message = "The only valid value for application_type is web."
  }

  // Validation for sampling percentage
  validation {
    condition = alltrue([
      for appi in var.application_insights_settings : contains([100, 50, 33, 25, 12.5, 8.3, 4, 2, 1], appi.sampling_percentage)
    ])
    error_message = "Valid Data Sampling percentages are 100, 50, 33, 25, 12.5, 8.3, 4, 2, and 1."
  }

  // Validation for location
  validation {
    condition = alltrue([
      for appi in var.application_insights_settings : contains([
        "West Europe",
        "North Europe",
      ], appi.resource_group_location)
    ])
    error_message = "Valid locations are West Europe and North Europe."
  }
}

// Common tags for all Azure resources
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}
