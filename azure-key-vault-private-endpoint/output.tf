// Output Block for Key Vault Private Endpoints
output "keyvault_private_endpoints_output" {
  description = "Attributes of created Key Vault private endpoints and DNS records."

  value = {
    // IDs of private endpoints.
    ids = {
      for key, pe in azurerm_private_endpoint.pep :
      key => pe.id # Mapping each key to its respective private endpoint ID
    },

    // IP addresses of private endpoints.
    ips = {
      for key, pe in azurerm_private_endpoint.pep :
      key => pe.private_service_connection[0].private_ip_address # Mapping each key to its respective IP address
    },
  }
}

// Output Block for Private DNS A Records
output "private_dns_a_records" {
  description = "FQDNs of the A records in the private DNS zone."

  value = {
    for key, record in data.azurerm_private_dns_a_record.records :
    key => record.fqdn
  }
}
