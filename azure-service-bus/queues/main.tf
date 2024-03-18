/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 13-01-2024
*/

// Resource definition for Azure Service Bus Queues
resource "azurerm_servicebus_queue" "queue" {
  // Loop through each queue in the servicebus_queues variable
  for_each = { for sbq in var.servicebus_queues : sbq.name => sbq }

  // Assign values from each queue object to the respective Service Bus Queue properties
  name                                    = each.value.name
  namespace_id                            = each.value.namespace_id
  enable_partitioning                     = each.value.enable_partitioning
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  lock_duration                           = each.value.lock_duration
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes != null ? each.value.max_message_size_in_kilobytes : null
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  requires_session                        = each.value.requires_session
  default_message_ttl                     = each.value.default_message_ttl != null ? each.value.default_message_ttl : null
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window != null ? each.value.duplicate_detection_history_time_window : null
  max_delivery_count                      = each.value.max_delivery_count
  status                                  = each.value.status
  enable_batched_operations               = each.value.enable_batched_operations
  auto_delete_on_idle                     = each.value.auto_delete_on_idle != null ? each.value.auto_delete_on_idle : null
  enable_express                          = each.value.enable_express
  forward_to                              = each.value.forward_to != null ? each.value.forward_to : null
  forward_dead_lettered_messages_to       = each.value.forward_dead_lettered_messages_to != null ? each.value.forward_dead_lettered_messages_to : null
}