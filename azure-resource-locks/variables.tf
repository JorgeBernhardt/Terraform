// Declares a variable "lock_info" that will be used to create resource locks
variable "lock_info" {
  description = "Information for creating resource locks"
  type = map(object({
    index               = string // An index identifier as a string
    name                = string
    lock_level          = string // The level of the lock as a string. Possible values are 'CanNotDelete' and 'ReadOnly'
    notes               = string
    resource_group_name = optional(string)
    resource_type       = optional(string)
    resource_name       = optional(string)
  }))
}
