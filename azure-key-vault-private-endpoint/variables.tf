variable "private_endpoints" {
  description = "Details for the Key Vault Private Endpoints creation"
  type = map(object({
    resource_group_name   = string
    virtual_network_name  = string
    subnet_name           = string
    resource_id_to_link   = string
    tags                  = map(string)
  }))
  default = {}
}
