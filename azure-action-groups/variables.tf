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

// Variable for actions groups settings
variable "action_groups" {
  description = "Map of action groups"
  type = map(object({
    enabled      = bool
    short_name   = string
    email_name   = string
    email        = string
    sms_name     = string
    country      = string
    phone        = string
    webhook_name = string
    service_uri  = string
  }))
}
