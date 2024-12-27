variable "alarms" {
  type        = list(string)
  description = "List of cloudwatch alarms to display"
}

locals {
  widget = {
    type : "alarm",
    width : 24, #fixed
    height : (ceil(length(var.alarms) / 4) + 1),
    properties : {
      title : "Alarm statuses",
      alarms : var.alarms
    }
  }
}

output "widget" {
  value       = local.widget
  description = "Widget definition"
}
