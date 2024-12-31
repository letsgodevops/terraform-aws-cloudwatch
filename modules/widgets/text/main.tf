variable "text" {
  type        = string
  description = "Name displayed on the widget"
}

variable "details" {
  default     = ""
  description = "Secondary text displayed on the widget"
}

locals {
  widget = {
    type : "text",
    width : 24
    height : var.details == "" ? 1 : 2
    properties : {
      markdown : "# ${var.text}\n ${var.details}"
    }
  }
}

output "widget" {
  value       = local.widget
  description = "Widget definition"
}
