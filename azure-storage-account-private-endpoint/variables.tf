// Define a variable for configuring private endpoints
variable "private_endpoints" {
  description = "Details for the Private Endpoints creation"
  type = map(object({
    resource_group_name              = string
    virtual_network_name             = string
    subnet_name                      = string
    resource_id_to_link              = string
    private_service_subresource_name = string
    tags                             = map(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for ep in values(var.private_endpoints) :
      contains(["blob", "file", "queue", "table"], ep.private_service_subresource_name)
    ])
    error_message = "Valid values for private_service_subresource_name are: blob, file, queue, table."
  }
}
