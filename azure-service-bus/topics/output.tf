// Output definition for Service Bus Topic details
output "servicebus_topic_details" {
  description = "A map of Service Bus topic details, including each topic's ID and name."
  value = {
    for sbt in azurerm_servicebus_topic.topic : sbt.name => {
      topic_id   = sbt.id   # The unique identifier of the topic
      topic_name = sbt.name # The name of the topic
    }
  }
}
