// Output for the resource group
output "resource_group" {
  description = "Information about the resource group"
  value = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    id       = azurerm_resource_group.rg.id
  }
}

// Output for the shared image gallery
output "shared_image_gallery" {
  description = "Information about the shared image gallery"
  value = {
    name        = azurerm_shared_image_gallery.sig.name
    location    = azurerm_shared_image_gallery.sig.location
    id          = azurerm_shared_image_gallery.sig.id
  }
}

// Output for the shared image
output "shared_image" {
  description = "Information about the shared image"
  value = {
    name        = azurerm_shared_image.si.name
    location    = azurerm_shared_image.si.location
    id          = azurerm_shared_image.si.id
    os_type     = azurerm_shared_image.si.os_type
    publisher   = azurerm_shared_image.si.identifier[0].publisher
    offer       = azurerm_shared_image.si.identifier[0].offer
    sku         = azurerm_shared_image.si.identifier[0].sku
  }
}

// Output for the shared image versions
output "shared_image_versions" {
  description = "Information about the shared image versions"
  value = {
    for k, v in azurerm_shared_image_version.siv : k => {
      name                                     = v.name
      location                                 = v.location
      id                                       = v.id
      end_of_life_date                         = v.end_of_life_date
      exclude_from_latest                      = v.exclude_from_latest
      deletion_of_replicated_locations_enabled = v.deletion_of_replicated_locations_enabled
      replication_mode                         = v.replication_mode
      target_regions = [
        for tr in v.target_region : {
          name                   = tr.name
          regional_replica_count = tr.regional_replica_count
          storage_account_type   = tr.storage_account_type
        }
      ]
    }
  }
}
