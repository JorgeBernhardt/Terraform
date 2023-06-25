// Variable for Azure budgets settings
variable "budgets" {
  description = "List of budgets"
  type = list(object({
    name       = string
    amount     = number
    time_grain = string // Valid values are: "Monthly", "Quarterly", "Annually"
    start_date = string // Any valid start date in "YYYY-MM-DDT00:00:00Z" format
    end_date   = string // Any valid end date in "YYYY-MM-DDT00:00:00Z" format
    notifications = list(object({
      enabled        = bool
      threshold      = number
      operator       = string // Valid values are: "EqualTo", "GreaterThan", "GreaterThanOrEqualTo"
      threshold_type = string // Valid values are: "Actual", "Forecasted"
      contact_emails = list(string)
      contact_roles  = list(string) // Valid values are: "Owner", "Reader", "Contributor"
    }))
  }))
}
