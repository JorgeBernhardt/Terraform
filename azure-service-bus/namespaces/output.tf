output "namespaces_details" {
  value = {
    for namespace in azurerm_servicebus_namespace.namespace : namespace.name => {
      id   = namespace.id
      name = namespace.name
    }
  }
  description = "A map of the created Service Bus Namespace objects, providing each namespace's ID and name. This can be useful for integrating with other resources or outputs."
}
