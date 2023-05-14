// Output for the resource group ID
output "resource_group_id" {
  description = "The ID of the created resource group."
  value       = azurerm_resource_group.rg.id
}

// Output for the hub virtual network ID
output "hub_vnet_id" {
  description = "The ID of the created hub virtual network."
  value       = azurerm_virtual_network.hub_vnet.id
}

// Output for the hub subnets IDs
output "hub_subnets_ids" {
  description = "The IDs of the created subnets in the hub virtual network."
  value       = [for s in azurerm_subnet.hub_subnets : s.id]
}

// Output for the spoke virtual networks IDs
output "spoke_vnets_ids" {
  description = "The IDs of the created spoke virtual networks."
  value       = [for v in azurerm_virtual_network.spoke_vnets : v.id]
}

// Output for the default subnets in the spoke virtual networks IDs
output "spoke_default_subnets_ids" {
  description = "The IDs of the created default subnets in the spoke virtual networks."
  value       = [for s in azurerm_subnet.spoke_default_subnets : s.id]
}

// Output for the peering connections from the hub to the spokes IDs
output "hub_to_spoke_peering_ids" {
  description = "The IDs of the created peering connections from the hub to the spokes."
  value       = [for p in azurerm_virtual_network_peering.hub_to_spoke : p.id]
}

// Output for the peering connections from the spokes to the hub IDs
output "spoke_to_hub_peering_ids" {
  description = "The IDs of the created peering connections from the spokes to the hub."
  value       = [for p in azurerm_virtual_network_peering.spoke_to_hub : p.id]
}
