// Output the name and public IP address of the firewall
output "firewall_public_ip" {
  description = "The name and public IP address of the firewall"
  value = {
    name       = azurerm_public_ip.public_ip.name
    ip_address = azurerm_public_ip.public_ip.ip_address
  }
}

// Output the name and ID of the firewall
output "firewall_id" {
  description = "The name and ID of the firewall"
  value = {
    name = azurerm_firewall.firewall.name
    id   = azurerm_firewall.firewall.id
  }
}
