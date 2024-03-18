// Output definition for Service Bus Queue details
output "servicebus_queue_details" {
  value = {
    for sbq in azurerm_servicebus_queue.queue : sbq.name => {
      queue_id   = sbq.id   # The unique identifier of the queue
      queue_name = sbq.name # The name of the queue
    }
  }
}