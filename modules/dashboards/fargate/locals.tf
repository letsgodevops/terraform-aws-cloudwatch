data "aws_region" "current" {}

locals {
  metrics = {
    fargate = {
      sport    = ["AWS/Usage", "ResourceCount", "Type", "Resource", "Resource", "vCPU", "Service", "Fargate", "Class", "Standard/Spot", { "region" : data.aws_region.current.name }],
      ondemand = ["AWS/Usage", "ResourceCount", "Type", "Resource", "Resource", "vCPU", "Service", "Fargate", "Class", "Standard/OnDemand", { "region" : data.aws_region.current.name }]
    }
  }
}

module "name" {
  source = "/modules/widgets/text"

  text = "Fargate Spot vs OnDemand"
}

module "vcpus" {
  source = "/modules/widgets/value-chart"

  name = "Fargate Spot vs OnDemand (${data.aws_region.current.name})"
  metrics = [
    local.metrics.fargate.sport,
    local.metrics.fargate.ondemand
  ]
}


