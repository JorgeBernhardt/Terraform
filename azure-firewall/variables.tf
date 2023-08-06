// Variable for the resource group details
variable "resource_group" {
  description = "The details of the resource group in which resources will be created"
  type = object({
    name = string
  })
}

// Variable for the virtual network details
variable "vnet" {
  description = "The details of the existing virtual network"
  type = object({
    name = string
  })
}

// Variable for the subnet details
variable "subnet" {
  description = "The details of the subnet to be created"
  type = object({
    name             = string
    address_prefixes = list(string)
  })
}

// Variable for the public IP details
variable "public_ip" {
  description = "The details of the public IP to be created"
  type = object({
    name              = string
    allocation_method = string
    sku               = string
  })
}

// Variable for the Azure firewall
variable "firewall" {
  description = "The details of the Azure Firewall to be created"
  type = object({
    name     = string
    sku_name = string
    sku_tier = string
    ip_configuration = object({
      name = string
    })
  })
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
