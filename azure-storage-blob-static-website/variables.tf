// Define a variable to hold configurations for multiple sites
variable "sites" {
  type = map(object({
    resource_group_name  = string
    storage_account_name = string
    location             = string
    index_document       = string
    error_404_document   = string
    index_html_path      = string
    error_404_html_path  = string
    deploy_cdn           = bool
  }))

  validation {
    // Validate that the storage account name is between 3 and 24 characters in length and only contains lower-case letters and numbers
    condition = alltrue([
      for k, v in var.sites :
      length(v.storage_account_name) >= 3 && length(v.storage_account_name) <= 24 && can(regex("^[a-z0-9]*$", v.storage_account_name))
    ])
    error_message = "The storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only."
  }
}


// Common tags for all Azure resources created
variable "tags" {
  description = "Common tags for all resources"

  // Define the type structure for the tags
  type = object({
    Environment = string
    Terraform   = string
  })

  // Default values for tags
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}
