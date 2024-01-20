# Variable definition for Service Bus Queues
variable "servicebus_queues" {
  description = "List of Service Bus Queues to be created"
  type = list(object({
    namespace_id                            = string
    name                                    = string
    enable_partitioning                     = bool
    max_size_in_megabytes                   = number
    lock_duration                           = string
    max_message_size_in_kilobytes           = number # Optional, default to null
    requires_duplicate_detection            = bool   # Optional, default to false
    requires_session                        = bool   # Optional, default to false
    default_message_ttl                     = string # Optional, default to null
    dead_lettering_on_message_expiration    = bool   # Optional, default to false
    duplicate_detection_history_time_window = string # Optional, default to null
    max_delivery_count                      = number # Optional, default to 10
    status                                  = string # Optional, default to "Active"
    enable_batched_operations               = bool   # Optional, default to true
    auto_delete_on_idle                     = string # Optional, default to null
    enable_express                          = bool   # Optional, default to false for Basic/Standard, true for Premium
    forward_to                              = string # Optional, default to null
    forward_dead_lettered_messages_to       = string # Optional, default to null
  }))
  default = []

  validation {
    condition     = alltrue([for q in var.servicebus_queues : can(regex("^[a-zA-Z0-9-]{3,50}$", q.name))])
    error_message = "All queue names must be between 3 and 50 characters and can only contain letters, numbers, and hyphens."
  }
  validation {
    condition     = alltrue([for q in var.servicebus_queues : contains([1024, 2048, 3072, 4096, 5120], q.enable_partitioning ? q.max_size_in_megabytes / 16 : q.max_size_in_megabytes)])
    error_message = "All max_size_in_megabytes values must be one of 1024, 2048, 3072, 4096, 5120 megabytes. If enable_partitioning is set to true, the specified queue size will be scaled by a factor of 16."
  }
  validation {
    condition = alltrue([
      for q in var.servicebus_queues :
      (q.lock_duration == null || can(regex("^PT([0-5]?[0-9]M)?$", q.lock_duration))) &&
      (q.auto_delete_on_idle == null || can(regex("^PT(([5-9]M)|([1-5]?[0-9][0-9]M)|([6-9]M[0-5]?[0-9]S)|([1-5]?[0-9][0-9]M[0-5]?[0-9]S)?)$", q.auto_delete_on_idle))) &&
      (q.default_message_ttl == null || can(regex("^PT([0-5]?[0-9]M([0-5]?[0-9]S)?)?$", q.default_message_ttl))) &&
      (q.duplicate_detection_history_time_window == null || can(regex("^PT([0-5]?[0-9]M([0-5]?[0-9]S)?)?$", q.duplicate_detection_history_time_window)))
    ])
    error_message = "The values for lock_duration, auto_delete_on_idle, default_message_ttl, and duplicate_detection_history_time_window must be either null or in ISO 8601 format."
  }
  validation {
    condition = alltrue([
      for q in var.servicebus_queues :
      q.status == null ||
      (q.status != null && (q.status == "Active" || q.status == "Creating" || q.status == "Deleting" || q.status == "Disabled" || q.status == "ReceiveDisabled" || q.status == "Renaming" || q.status == "SendDisabled" || q.status == "Unknown"))
    ])
    error_message = "The status must be either null or one of the following values: Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, SendDisabled, Unknown."
  }
}
