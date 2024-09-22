/*
  Author: Jorge Bernhardt
  Version: 1.1.0
  Date: 21-09-2024
*/

// Define the Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

// Define the Azure Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.networks
  name                = each.key
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

// Define local variable to flatten the subnet structures
locals {
  flattened_subnets = flatten([
    for vnet_key, vnet_value in var.networks : [
      for subnet in vnet_value.subnets : {
        vnet_name      = vnet_key
        subnet_name    = subnet.name
        address_prefix = subnet.address_prefix
      }
    ]
  ])
}

// Define the Azure Subnet
resource "azurerm_subnet" "subnet" {
  for_each = { for subnet in local.flattened_subnets : "${subnet.vnet_name}-${subnet.subnet_name}" => subnet }

  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = [each.value.address_prefix]

  delegation {
    name = "container-instance-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [azurerm_virtual_network.vnet]
}

// Define the Azure Container Group (ACI)
resource "azurerm_container_group" "aci" {
  for_each            = { for idx, aci in var.aci_instances : idx => aci }
  name                = each.value.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  restart_policy      = each.value.restart_policy

  ip_address_type = each.value.is_public ? "Public" : "Private"
  subnet_ids      = each.value.is_public ? null : [azurerm_subnet.subnet["${each.value.vnet_name}-${each.value.subnet_name}"].id]
  dns_name_label  = each.value.is_public ? each.value.dns_label : null

  dynamic "container" {
    for_each = each.value.containers
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory

      dynamic "ports" {
        for_each = container.value.ports
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
    }
  }

  # Image registry credential (optional for rate-limited Docker Hub access)
  image_registry_credential {
    server   = "index.docker.io"
    username = var.docker_username
    password = var.docker_password
  }

  tags       = var.tags
  depends_on = [azurerm_subnet.subnet]
}