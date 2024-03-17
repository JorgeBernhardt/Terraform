
// Defines the configuration for API Management instances
variable "api_managements" {
  description = "List of API Management objects including the resource group name and location for each."
  type = list(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    publisher_name                = string
    publisher_email               = string
    sku_name                      = string
    client_certificate_enabled    = bool
    virtual_network_type          = string
    min_api_version               = string
    public_network_access_enabled = bool
  }))

  validation {
    condition = alltrue([
      for api in var.api_managements : (
        length(api.name) > 0 &&
        length(api.resource_group_name) > 0 && 
        length(api.location) > 0 &&            
        length(api.publisher_name) > 0 &&
        length(api.publisher_email) > 0 &&
        contains(["Developer_1", "Basic_1", "Consumption_0", "Premium_1"], api.sku_name) &&
        contains(["None", "External", "Internal"], api.virtual_network_type)
      )
    ])
    error_message = "Invalid API Management configurations. Please check the values."
  }
}

// Common tags for all deployed resources
variable "tags" {
  description = "Common tags for all resources"
  type = object({
    Environment = string
    Terraform   = string
  })
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}

