/*
  Author: Jorge Bernhardt
  Version: 0.0.1
  Date: 17-02-2024
*/

// Resource definition for Azure Service Bus Topics with updated parameters
resource "azurerm_servicebus_topic" "topic" {
  // Loop through each topic in the servicebus_topics variable
  for_each = { for sbt in var.servicebus_topics : sbt.name => sbt }

  name                                    = each.value.name
  namespace_id                            = each.value.namespace_id
  status                                  = each.value.status
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  enable_batched_operations               = each.value.enable_batched_operations
  enable_express                          = each.value.enable_express
  enable_partitioning                     = each.value.enable_partitioning
  max_message_size_in_kilobytes           = each.value.max_message_size_in_kilobytes
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  support_ordering                        = each.value.support_ordering
}
