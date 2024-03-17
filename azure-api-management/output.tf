// Output for API Management Details
output "api_management_details" {
  description = "Details of the created API Management resources"
  value = {
    ids                   = [for api in azurerm_api_management.apim : api.id]
    gateway_urls          = [for api in azurerm_api_management.apim : api.gateway_url]
    developer_portal_urls = [for api in azurerm_api_management.apim : api.developer_portal_url]
  }
}
