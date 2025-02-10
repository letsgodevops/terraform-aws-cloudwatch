variable "name" {
  type        = string
  description = "Name of the dashboard"
}

variable "widgets" {
  type        = any
  description = "List of widgets to display on the dashboard"
}


locals {
  dashboard_body = {
    widgets : var.widgets
  }
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.name

  dashboard_body = jsonencode(local.dashboard_body)
}

