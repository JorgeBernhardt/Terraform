// Output the name of the resource group
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

// Output the list of virtual networks with their name and address space
output "virtual_networks" {
  description = "List of virtual networks with their name and address space"
  value = [
    for vnet in azurerm_virtual_network.vnet : {
      name          = vnet.name
      address_space = vnet.address_space
    }
  ]
}

// Output the list of subnets with their name, address prefix, and associated virtual network name
output "subnets" {
  description = "List of subnets with their name, address prefix, and associated virtual network name"
  value = [
    for subnet in azurerm_subnet.subnet : {
      name           = subnet.name
      address_prefix = subnet.address_prefixes
      vnet_name      = subnet.virtual_network_name
    }
  ]
}

// Output the details of the deployed ACI instances
output "aci_instances" {
  description = "Details of the deployed ACI instances"
  value = {
    for aci in azurerm_container_group.aci : aci.name => {
      name           = aci.name
      location       = aci.location
      restart_policy = aci.restart_policy
      resource_id    = aci.id
      ip_address     = aci.ip_address
      fqdn           = aci.fqdn
      containers = [
        for container in aci.container : {
          name   = container.name
          image  = container.image
          cpu    = container.cpu
          memory = container.memory
          ports  = [
            for port in container.ports : {
              port     = port.port
              protocol = port.protocol
            }
          ]
        }
      ]
    }
  }
}
