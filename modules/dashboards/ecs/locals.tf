

locals {
  metrics = {
    ecs = {
      CPUUtilization_max    = ["AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", local.cluster_name, { "stat" : "Maximum" }],
      MemoryUtilization_max = ["AWS/ECS", "MemoryUtilization", "ServiceName", var.service_name, "ClusterName", local.cluster_name, { "stat" : "Maximum" }]
    },

    ecs_ci = {
      DeploymentCount = ["ECS/ContainerInsights", "DeploymentCount", "ServiceName", var.service_name, "ClusterName", local.cluster_name],
      TaskSetCount    = ["ECS/ContainerInsights", "TaskSetCount", "ServiceName", var.service_name, "ClusterName", local.cluster_name],

      RunningTaskCount = ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.service_name, "ClusterName", local.cluster_name, { "stat" : "Minimum" }],
      DesiredTaskCount = ["ECS/ContainerInsights", "DesiredTaskCount", "ServiceName", var.service_name, "ClusterName", local.cluster_name, { "stat" : "Maximum" }],
      PendingTaskCount = ["ECS/ContainerInsights", "PendingTaskCount", "ServiceName", var.service_name, "ClusterName", local.cluster_name, { "stat" : "Maximum" }],

      NetworkRxBytes = ["ECS/ContainerInsights", "NetworkRxBytes", "ServiceName", var.service_name, "ClusterName", local.cluster_name],
      NetworkTxBytes = ["ECS/ContainerInsights", "NetworkTxBytes", "ServiceName", var.service_name, "ClusterName", local.cluster_name],

      CpuReserved    = ["ECS/ContainerInsights", "CpuReserved", "ServiceName", var.service_name, "ClusterName", local.cluster_name, {}],
      MemoryReserved = ["ECS/ContainerInsights", "MemoryReserved", "ServiceName", var.service_name, "ClusterName", local.cluster_name, {}],

      StorageReadBytes  = ["ECS/ContainerInsights", "StorageReadBytes", "ServiceName", var.service_name, "ClusterName", local.cluster_name],
      StorageWriteBytes = ["ECS/ContainerInsights", "StorageWriteBytes", "ServiceName", var.service_name, "ClusterName", local.cluster_name],

      MemoryUtilized = ["ECS/ContainerInsights", "MemoryUtilized", "ServiceName", var.service_name, "ClusterName", local.cluster_name, ],
      CpuUtilized    = ["ECS/ContainerInsights", "CpuUtilized", "ServiceName", var.service_name, "ClusterName", local.cluster_name],
    },

    alb = {
      HealthyHostCount              = ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      UnHealthyHostCount            = ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      HTTPCode_Target_2XX_Count     = ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      HTTPCode_Target_2XX_Count_Sum = ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name, { "color" : "#2ca02c", "stat" : "Sum" }],
      HTTPCode_Target_4XX_Count     = ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      HTTPCode_Target_4XX_Count_Sum = ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name, { "color" : "#ffbb78", "stat" : "Sum" }],
      HTTPCode_Target_5XX_Count     = ["AWS/ApplicationELB", "HealthyHTTPCode_Target_5XX_CountHostCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      HTTPCode_Target_5XX_Count_Sum = ["AWS/ApplicationELB", "HealthyHTTPCode_Target_5XX_CountHostCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name, { "color" : "#d62728", "stat" : "Sum" }],
      RequestCountPerTarget         = ["AWS/ApplicationELB", "RequestCountPerTarget", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      RequestCount                  = ["AWS/ApplicationELB", "RequestCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
      RequestCount_Sum              = ["AWS/ApplicationELB", "RequestCount", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name, { "stat" : "Sum" }],
      TargetResponseTime            = ["AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", local.alb_target_group, "LoadBalancer", local.alb_lb_name],
    }
  }
  alb_target_group = var.alb_target_group_arn != null ? data.aws_lb_target_group.this.0.arn_suffix : ""
  alb_lb_name      = var.alb_target_group_arn != null ? replace(one(data.aws_lb_target_group.this.0.load_balancer_arns), "/^arn:.*:loadbalancer\\//", "") : ""
  cluster_name     = replace(var.cluster_id, "/^arn:.*:cluster\\//", "")
}


data "aws_lb_target_group" "this" {
  count = var.alb_target_group_arn != null ? 1 : 0
  arn   = var.alb_target_group_arn
}


module "name" {
  source = "../../../modules/widgets/text"

  text = "ECS Service: ${var.section_name}"
}

module "ecs_container_insights" {
  source = "../../../modules/widgets/value"

  name = "(${var.name})"
  metrics = [
    local.metrics.ecs_ci.DesiredTaskCount,
    local.metrics.ecs_ci.RunningTaskCount,
    local.metrics.ecs_ci.PendingTaskCount,
    local.metrics.ecs_ci.MemoryReserved,
    local.metrics.ecs_ci.CpuReserved
  ]

  width = 24
}

module "ecs_usage" {
  source = "../../../modules/widgets/value-chart"

  name = var.name
  metrics = [
    local.metrics.ecs.CPUUtilization_max,
    local.metrics.ecs.MemoryUtilization_max
  ]
}

module "ecs_tesks" {
  source = "../../../modules/widgets/value-chart"

  name = "Tasks"
  metrics = [
    local.metrics.ecs_ci.DesiredTaskCount,
    local.metrics.ecs_ci.RunningTaskCount,
    local.metrics.ecs_ci.PendingTaskCount,
  ]
}

module "alb_summary" {
  source = "../../../modules/widgets/value"
  count  = var.alb_target_group_arn != null ? 1 : 0

  name = "(ALB for ${var.name})"
  metrics = [
    local.metrics.alb.HealthyHostCount,
    local.metrics.alb.UnHealthyHostCount,
    local.metrics.alb.RequestCount,
    local.metrics.alb.TargetResponseTime,
    local.metrics.alb.HTTPCode_Target_2XX_Count,
    local.metrics.alb.HTTPCode_Target_4XX_Count,
    local.metrics.alb.HTTPCode_Target_5XX_Count
  ]

  width = 24
}

module "alb_rq_count" {
  source = "../../../modules/widgets/chart"
  count  = var.alb_target_group_arn != null ? 1 : 0

  name    = "Request Count (${var.name})"
  metrics = [local.metrics.alb.RequestCount_Sum]
}

module "alb_response_time" {
  source = "../../../modules/widgets/chart"
  count  = var.alb_target_group_arn != null ? 1 : 0

  name    = "Target Response Time (${var.name})"
  metrics = [local.metrics.alb.TargetResponseTime]
}

module "alb_response" {
  source = "../../../modules/widgets/chart"
  count  = var.alb_target_group_arn != null ? 1 : 0

  stacked = true
  name    = "Response codes (${var.name})"
  metrics = [
    local.metrics.alb.HTTPCode_Target_2XX_Count_Sum,
    local.metrics.alb.HTTPCode_Target_4XX_Count_Sum,
    local.metrics.alb.HTTPCode_Target_5XX_Count_Sum
  ]
}



