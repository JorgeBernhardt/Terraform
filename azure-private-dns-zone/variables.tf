// Variable for Azure Resource Group settings
variable "resource_group" {
  description = "Azure Resource Group settings"
  type = object({
    name     = string
    location = string
  })
}

// Variable for tags
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

// Variable for private DNS zones
variable "dns_zones" {
  description = "Settings for private DNS zones"
  type = list(object({
    zone_name = string
  }))
}

// Variable for DNS records
variable "dns_records" {
  description = "Settings for DNS records"
  type = list(object({
    zone_name   = string
    record_name = string
    ttl         = number
    ip          = string
  }))
}
