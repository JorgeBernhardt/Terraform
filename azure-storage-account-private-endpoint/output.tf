# Output Block for Storage Account Private Endpoints
output "private_endpoints_output" {
  description = "Attributes of created private endpoints and DNS records."
  value = {
    # IDs of private endpoints.
    ids = { for key, pe in azurerm_private_endpoint.pep : key => pe.id },

    # IP addresses of private endpoints.
    ips = { for key, pe in azurerm_private_endpoint.pep : key => pe.private_service_connection[0].private_ip_address },

    # FQDNs of DNS A records.
    dns = { for key, dns in azurerm_private_dns_a_record.pdnsrecord : key => dns.fqdn }
  }
}
