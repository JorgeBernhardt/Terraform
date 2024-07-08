/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 02-07-2024
*/

// Define the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

// Get the existing Azure image
data "azurerm_image" "img" {
  name                = var.existing_image.name
  resource_group_name = var.existing_image.resource_group_name
}

// Define the shared image gallery
resource "azurerm_shared_image_gallery" "sig" {
  name                = var.shared_image_gallery.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = var.shared_image_gallery.description
  tags                = var.tags

  sharing {
    permission = var.shared_image_gallery.sharing_permission

    community_gallery {
      eula            = var.shared_image_gallery.eula
      prefix          = var.shared_image_gallery.prefix
      publisher_email = var.shared_image_gallery.publisher_email
      publisher_uri   = var.shared_image_gallery.publisher_uri
    }
  }
}

// Define the shared image
resource "azurerm_shared_image" "si" {
  name                = var.shared_image.name
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = var.shared_image.os_type

  identifier {
    publisher = var.shared_image.publisher
    offer     = var.shared_image.offer
    sku       = var.shared_image.sku
  }

  // Optional fields
  description                  = var.shared_image.description
  specialized                  = var.shared_image.specialized
  architecture                 = var.shared_image.architecture
  hyper_v_generation           = var.shared_image.hyper_v_generation
  max_recommended_vcpu_count   = var.shared_image.max_recommended_vcpu_count
  min_recommended_vcpu_count   = var.shared_image.min_recommended_vcpu_count
  max_recommended_memory_in_gb = var.shared_image.max_recommended_memory_in_gb
  min_recommended_memory_in_gb = var.shared_image.min_recommended_memory_in_gb
  end_of_life_date             = var.shared_image.end_of_life_date
  tags                         = var.tags

  depends_on = [
    azurerm_shared_image_gallery.sig,
  ]
}

// Define the shared image version
resource "azurerm_shared_image_version" "siv" {
  for_each = var.shared_image_versions

  name                = each.key
  gallery_name        = azurerm_shared_image_gallery.sig.name
  image_name          = azurerm_shared_image.si.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group.location
  managed_image_id    = data.azurerm_image.img.id

  target_region {
    name                   = var.resource_group.location
    regional_replica_count = each.value.regional_replica_count
    storage_account_type   = each.value.storage_account_type
  }

  target_region {
    name                   = each.value.target_region_name
    regional_replica_count = each.value.regional_replica_count
    storage_account_type   = each.value.storage_account_type
  }

  // Optional fields
  end_of_life_date                         = each.value.end_of_life_date
  exclude_from_latest                      = each.value.exclude_from_latest
  deletion_of_replicated_locations_enabled = each.value.deletion_of_replicated_locations_enabled
  replication_mode                         = each.value.replication_mode
  tags                                     = var.tags

  depends_on = [
    azurerm_shared_image.si, // Versions depend on the image
  ]
}
