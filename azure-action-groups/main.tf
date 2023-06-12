/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 06-06-2023
*/

// Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

resource "azurerm_monitor_action_group" "ag" {
  for_each            = var.action_groups
  enabled             = each.value.enabled
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = each.value.short_name

  email_receiver {
    name          = each.value.email_name
    email_address = each.value.email
  }

  sms_receiver {
    name         = each.value.sms_name
    country_code = each.value.country
    phone_number = each.value.phone
  }

  webhook_receiver {
    name        = each.value.webhook_name
    service_uri = each.value.service_uri
  }

  tags = var.tags
}
