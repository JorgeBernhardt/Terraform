// Variable definition for Service Bus Topics
variable "servicebus_topics" {
  description = "List of Service Bus Topics to be created"
  type = list(object({
    name                                    = string
    namespace_id                            = string
    status                                  = optional(string)
    auto_delete_on_idle                     = optional(string)
    default_message_ttl                     = optional(string)
    duplicate_detection_history_time_window = optional(string)
    enable_batched_operations               = optional(bool)
    enable_express                          = optional(bool)
    enable_partitioning                     = optional(bool)
    max_message_size_in_kilobytes           = optional(number)
    max_size_in_megabytes                   = optional(number)
    requires_duplicate_detection            = optional(bool)
    support_ordering                        = optional(bool)
  }))

  validation {
    # Ensure all topic names are not empty and meet naming conventions
    condition     = alltrue([for t in var.servicebus_topics : t.name != "" && length(t.name) <= 50])
    error_message = "All topic names must be non-empty strings of no more than 50 characters."
  }

  validation {
    # Validate namespace_id is not empty
    condition     = alltrue([for t in var.servicebus_topics : t.namespace_id != ""])
    error_message = "Each topic must have a non-empty namespace_id."
  }

  validation {
    # Validate that if enable_partitioning is true, max_size_in_megabytes must be one of the supported values for partitioned entities
    condition = alltrue([for t in var.servicebus_topics :
    !t.enable_partitioning || (t.enable_partitioning && contains([1024, 2048, 3072, 4096, 5120], t.max_size_in_megabytes))])
    error_message = "For partitioned topics, max_size_in_megabytes must be one of the following values: 1024, 2048, 3072, 4096, 5120."
  }

  validation {
    # Validate status field to ensure it's either "Active" or "Disabled" if provided
    condition = alltrue([for t in var.servicebus_topics :
    t.status == null || contains(["Active", "Disabled"], t.status)])
    error_message = "The status, if provided, must be either 'Active' or 'Disabled'."
  }
}
