// Definition of common tags for all Service Bus namespaces
variable "tags" {
  description = "Common tags for all Service Bus namespaces."
  type        = map(string) 
}

// Configuration details for Service Bus namespaces
variable "namespaces" {
  description = "A map of Service Bus Namespace configurations"
  type = map(object({
    name                          = string 
    location                      = string 
    resource_group_name           = string  // Name of the Azure resource group
    sku                           = string  // SKU type of the Service Bus namespace

    // Following attributes are optional and specific to 'Premium' SKU
    capacity                      = number  // Messaging units for the namespace, applicable only for 'Premium'
    zone_redundant                = bool    // Zone redundancy, applicable only for 'Premium'

    // General optional attributes for the namespace
    local_auth_enabled            = bool    // Local authorization enabled status
    public_network_access_enabled = bool    // Public network access enabled status
    minimum_tls_version           = string  // Minimum TLS version for the namespace

    // Optional configurations for advanced features
    identity                      = map(string) // Managed service identity configurations
    customer_managed_key          = map(string) // Customer-managed key configurations
    network_rule_set              = object({   // Network rule set configurations
      default_action           = string
      ip_rules                 = list(string)
      trusted_services_allowed = optional(bool)
    })
  }))
  default = {}  

  // Validation to ensure 'sku' is either 'Basic', 'Standard', or 'Premium'
  validation {
    condition     = alltrue([for ns in var.namespaces : contains(["Basic", "Standard", "Premium"], ns.sku)])
    error_message = "Each namespace must have a 'sku' that is either 'Basic', 'Standard', or 'Premium'."
  }

  // Validation for 'capacity' attribute for 'Premium' SKU
  validation {
    condition     = alltrue([for ns in var.namespaces : ns.sku != "Premium" || (ns.sku == "Premium" && contains([0, 1, 2, 4, 8, 16], ns.capacity))])
    error_message = "For 'Premium' SKU, 'capacity' must be one of [0, 1, 2, 4, 8, 16]. For 'Basic' or 'Standard' SKUs, 'capacity' must be 0."
  }
}
