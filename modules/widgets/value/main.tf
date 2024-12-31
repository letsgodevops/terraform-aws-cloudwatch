data "aws_region" "current" {}

variable "name" {
  type        = string
  description = "Name displayed on the widget"
}

variable "metrics" {
  type        = list(any)
  description = "List of metrics to display"
}

variable "width" {
  default     = -1
  description = "Width of the widget (-1 for auto width - useful for multiple widgets in a line)"
}

locals {
  width = (min(length(var.metrics) * 3 + 1, 24))
  widget = {
    type : "metric",
    width : var.width < 0 ? local.width : var.width
    height : 4,
    properties : {
      title : var.name
      view : "singleValue",
      metrics : var.metrics
      region : data.aws_region.current.name,
      period : 60,
    }
  }
}

output "widget" {
  value       = local.widget
  description = "Widget definition"
}

output "width" {
  value       = local.width
  description = "Width of the widget"
}
