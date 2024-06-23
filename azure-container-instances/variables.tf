// Define the name of the resource group
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

// Define the location of the resource group
variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

// Define the virtual networks and their subnets
variable "networks" {
  description = "Map of virtual networks and their subnets"
  type = map(object({
    address_space = string
    subnets = list(object({
      name           = string
      address_prefix = string
    }))
  }))
}

// Define the Azure Container Instances (ACI) configurations
variable "aci_instances" {
  type = map(object({
    name           = string
    vnet_name      = string
    subnet_name    = string
    containers     = list(object({
      name    = string
      image   = string
      cpu     = number
      memory  = number
      ports   = list(object({
        port     = number
        protocol = string
      }))
    }))
    is_public      = bool
    restart_policy = string
    dns_label      = string
  }))
  // Validation for the ports protocol
  validation {
      condition     = alltrue([for aci in var.aci_instances : alltrue([for container in aci.containers : alltrue([for port in container.ports : port.protocol == "TCP" || port.protocol == "UDP"])])])
      error_message = "Protocol must be either 'TCP' or 'UDP'."
  }
  // Validation for the restart policy
  validation {
    condition     = alltrue([for aci in var.aci_instances : aci.restart_policy == "Always" || aci.restart_policy == "OnFailure" || aci.restart_policy == "Never"])
    error_message = "Restart policy must be either 'Always', 'OnFailure', or 'Never'."
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