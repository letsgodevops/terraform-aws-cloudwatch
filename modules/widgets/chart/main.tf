data "aws_region" "current" {}

variable "name" {
  type        = string
  description = "Name displayed on the widget"
}

variable "metrics" {
  type        = list(list(string))
  description = "List of metrics to display"
}

variable "stacked" {
  type        = bool
  default     = false
  description = "Use stacked line chart"
}

variable "width" {
  default     = 24
  description = "Width of the widget (useful for multiple widgets in a line)"
}

locals {
  widget = {
    type : "metric",
    width : var.width,
    height : 4,
    properties : {
      title : var.name
      view : "timeSeries",
      metrics : var.metrics
      region : data.aws_region.current.name
      period : 60,
      stacked : var.stacked
    }
  }
}

output "widget" {
  value       = local.widget
  description = "Widget definition"
}
