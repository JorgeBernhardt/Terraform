// Output the IDs of the created budgets
output "budget_ids" {
  description = "The IDs of the created budgets"
  value       = { for b in azurerm_consumption_budget_subscription.budget : b.name => b.id }
}

// Output the names of the created budgets
output "budget_names" {
  description = "The names of the created budgets"
  value       = [for b in azurerm_consumption_budget_subscription.budget : b.name]
}
