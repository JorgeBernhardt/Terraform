// List of created Azure DevOps service connection names
output "service_connections" {
  description = "List of created Azure DevOps service connections."
  value = [
    for sc in azuredevops_serviceendpoint_azurerm.connections :
    {
      id   = sc.id
      name = sc.service_endpoint_name
    }
  ]
}

// List of created federated identity credential names
output "federated_identity_credentials" {
  description = "List of created federated identity credentials in Azure AD."
  value = [
    for fid in azurerm_federated_identity_credential.creds :
    {
      id   = fid.id
      name = fid.name
    }
  ]
}


