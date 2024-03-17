/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 17-03-2024
*/

// Defines and configures Azure API Management instances
resource "azurerm_api_management" "apim" {
  for_each = { for api in var.api_managements : api.name => api }

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  publisher_name      = each.value.publisher_name
  publisher_email     = each.value.publisher_email
  sku_name            = each.value.sku_name

  client_certificate_enabled    = each.value.client_certificate_enabled
  virtual_network_type          = each.value.virtual_network_type
  min_api_version               = each.value.min_api_version
  public_network_access_enabled = each.value.public_network_access_enabled

  tags = var.tags
}
