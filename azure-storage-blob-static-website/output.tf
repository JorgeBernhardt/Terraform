// Output block of code for display essential information about static websites deployed
output "site_info" {
  value = {
    for key, sa in azurerm_storage_account.sa :
    key => {
      storage_account_name = sa.name,
      static_website_url   = "https://${sa.primary_web_host}",
      cdn_url              = var.sites[key].deploy_cdn ? "https://${azurerm_cdn_endpoint.cdn_endpoint[key].name}.azureedge.net" : null,
    }
  }
  description = "Details of the static websites, including storage account names, URLs, and optional CDN URLs."
}
