/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 04-11-2023
*/

locals {
  sites = var.sites
}

// Resource Group for each site
resource "azurerm_resource_group" "rg" {
  for_each = local.sites

  name     = each.value.resource_group_name
  location = each.value.location
  tags     = var.tags
}

// Storage Account for each site to host static content
resource "azurerm_storage_account" "sa" {
  for_each = local.sites

  name                      = each.value.storage_account_name
  resource_group_name       = azurerm_resource_group.rg[each.key].name
  location                  = azurerm_resource_group.rg[each.key].location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  static_website {
    index_document     = each.value.index_document
    error_404_document = each.value.error_404_document
  }

  tags = var.tags
}

// Blob for the index page of each site
resource "azurerm_storage_blob" "index_blob" {
  for_each = local.sites

  name                   = each.value.index_document
  storage_account_name   = azurerm_storage_account.sa[each.key].name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = file(each.value.index_html_path)
  content_type           = "text/html"
}

// Blob for the error page of each site
resource "azurerm_storage_blob" "error_blob" {
  for_each = local.sites

  name                   = each.value.error_404_document
  storage_account_name   = azurerm_storage_account.sa[each.key].name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = file(each.value.error_404_html_path)
  content_type           = "text/html"
}

// CDN Profile for sites where CDN is requested
resource "azurerm_cdn_profile" "cdn_profile" {
  for_each = { for k, v in local.sites : k => v if v.deploy_cdn == true }

  name                = "${each.value.storage_account_name}-cdnprofile"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  sku                 = "Standard_Microsoft"
  tags                = var.tags
}

// CDN Endpoint for sites where CDN is requested
resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  for_each = { for k, v in local.sites : k => v if v.deploy_cdn == true }

  name                = "${each.value.storage_account_name}-cdnendpoint"
  profile_name        = azurerm_cdn_profile.cdn_profile[each.key].name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  is_http_allowed     = false
  is_https_allowed    = true

  origin {
    name      = "contentOrigin"
    host_name = azurerm_storage_account.sa[each.key].primary_web_host
  }

  origin_host_header = azurerm_storage_account.sa[each.key].primary_web_host
  tags               = var.tags
}
