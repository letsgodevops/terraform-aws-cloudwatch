variable "name" {
  type        = string
  description = "Name displayed on the widget"
}

variable "metrics" {
  type        = list(any)
  description = "List of metrics to display"
}

variable "stacked" {
  type        = bool
  default     = false
  description = "Use stacked line chart"
}

module "current" {
  source = "github.com/letsgodevops/terraform-aws-cloudwatch//modules/widgets/value?ref=0.0.1"

  name    = "Current usage (${var.name})"
  metrics = var.metrics
}

module "historical" {
  source = "github.com/letsgodevops/terraform-aws-cloudwatch//modules/widgets/chart?ref=0.0.1"

  width   = (24 - module.current.width) # Fill reminging space (this way widget will display next to current value)
  name    = "Usage (${var.name})"
  metrics = var.metrics
  stacked = var.stacked
}

output "widgets" {
  value       = [module.current.widget, module.historical.widget]
  description = "Widgets definition"
}
