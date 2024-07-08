// Define the resource group details
variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

// Define the existing image details
variable "existing_image" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

// Define the shared image gallery details
variable "shared_image_gallery" {
  description = "Shared image gallery details"
  type = object({
    name               = string
    description        = optional(string)
    sharing_permission = optional(string)
    eula               = optional(string)
    prefix             = optional(string)
    publisher_email    = optional(string)
    publisher_uri      = optional(string)
  })

  validation {
    condition     = contains(["Community", "Groups", "Private"], var.shared_image_gallery.sharing_permission)
    error_message = "sharing_permission must be one of 'Community', 'Groups', or 'Private'."
  }
}

// Define the shared image details
variable "shared_image" {
  description = "Shared image details"
  type = object({
    name                         = string
    os_type                      = string
    publisher                    = string
    offer                        = string
    sku                          = string
    description                  = optional(string)
    specialized                  = optional(bool)
    architecture                 = optional(string)
    hyper_v_generation           = optional(string)
    max_recommended_vcpu_count   = optional(number)
    min_recommended_vcpu_count   = optional(number)
    max_recommended_memory_in_gb = optional(number)
    min_recommended_memory_in_gb = optional(number)
    end_of_life_date             = optional(string)
  })

  validation {
    condition     = contains(["Linux", "Windows"], var.shared_image.os_type)
    error_message = "os_type must be either 'Linux' or 'Windows'."
  }

  validation {
    condition     = contains(["x64", "Arm64"], var.shared_image.architecture)
    error_message = "architecture must be either 'x64' or 'Arm64'."
  }

  validation {
    condition     = contains(["V1", "V2"], var.shared_image.hyper_v_generation)
    error_message = "hyper_v_generation must be either 'V1' or 'V2'."
  }
}

// Define the shared image versions details
variable "shared_image_versions" {
  description = "Shared image versions details"
  type = map(object({
    regional_replica_count                   = number
    storage_account_type                     = string
    target_region_name                       = string
    end_of_life_date                         = optional(string)
    exclude_from_latest                      = optional(bool)
    deletion_of_replicated_locations_enabled = optional(bool)
    replication_mode                         = optional(string)
  }))

  validation {
    condition     = alltrue([for v in var.shared_image_versions : contains(["Standard_LRS", "Premium_LRS", "Standard_ZRS"], v.storage_account_type)])
    error_message = "storage_account_type must be one of 'Standard_LRS', 'Premium_LRS', or 'Standard_ZRS'."
  }

  validation {
    condition     = alltrue([for v in var.shared_image_versions : contains(["Full", "Shallow"], v.replication_mode)])
    error_message = "replication_mode must be either 'Full' or 'Shallow'."
  }
}

// Define common tags for all resources
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "www.jorgebernhardt.com"
    Terraform   = "true"
  }
}