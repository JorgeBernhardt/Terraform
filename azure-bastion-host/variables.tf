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
    name                = string 
    resource_group_name = string 
  })
}

// Variable for the subnet details
variable "subnet" {
  description = "The details of the subnet to be created"
  type = object({
    name             = string // The subnet name must be "AzureBastionSubnet".
    address_prefixes = list(string) // The subnet size must be /26 or larger.
  })
}

// Variable for the public IP details
variable "public_ip" {
  description = "The details of the public IP to be created"
  type = object({
    name              = string 
    allocation_method = string // The Public IP address assignment/allocation method must be Static.
    sku               = string // The Public IP address SKU must be Standard.
  })
}

// Variable for the Azure Bastion Host details
variable "bastion_host" {
  description = "The details of the Azure Bastion Host to be created"
  type = object({
    name                   = string 
    sku                    = string // SKU of the Azure Bastion Host, either "Basic" or "Standard"
    copy_paste_enabled     = bool 
    file_copy_enabled      = bool 
    ip_connect_enabled     = bool 
    scale_units            = number /// Number of scale units for the Azure Bastion Host, between 2-50
    shareable_link_enabled = bool 
    tunneling_enabled      = bool 
    ip_configuration = object({
      name = string // Name of the IP configuration for the Azure Bastion Host.
    })
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
