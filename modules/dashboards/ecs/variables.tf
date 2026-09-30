variable "cluster_id" {
  type        = string
  description = "ECS cluster name"
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALB target group ARN"
  default     = null
}

variable "alb_enabled" {
  type        = bool
  description = "Add ALB widgets. Set it when alb_target_group_arn is not known at plan time (new target group), otherwise count fails. Defaults to alb_target_group_arn != null."
  default     = null
}

variable "name" {
  type        = string
  description = "Name displayed on the widget"
}

variable "service_name" {
  type        = string
  description = "Full name displayed on the widget"

}

variable "section_name" {
  type        = string
  description = "Service display name"
}
