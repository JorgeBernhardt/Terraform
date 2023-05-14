// Define the variable for the hub network. This is an object with several properties.
variable "hub_network" {
  type = object({
    vnetName          = string // The name of the virtual network for the hub
    resourceGroupName = string // The name of the resource group where the hub network will be created
    location          = string // The Azure region where the hub network will be located
    addressSpace      = string // The IP address space for the hub network
    dnsServers        = list(string) // The list of DNS servers for the hub network
    tags              = map(string) // The tags to be applied to the hub network resources
    subnetNames       = list(string) // The list of subnet names within the hub network
    subnetPrefixes    = list(string) // The list of subnet prefixes corresponding to the subnet names in the hub network
  })
}

// Define the variable for the spoke networks. This is a list of objects, each with several properties.
variable "spoke_networks" {
  type = list(object({
    vnetName            = string // The name of the virtual network for each spoke
    addressSpace        = string // The IP address space for each spoke network
    defaultSubnetName   = string // The name of the default subnet within each spoke network
    defaultSubnetPrefix = string // The subnet prefix for the default subnet within each spoke network
    location            = string // The Azure region where each spoke network will be located
  }))
}
