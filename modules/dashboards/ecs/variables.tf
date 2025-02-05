variable "cluster_id" {
  type        = string
  description = "ECS cluster name"
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALB target group ARN"
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
