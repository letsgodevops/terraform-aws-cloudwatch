locals {
  metrics = {
    rds = {
      DBInstanceIdentifier      = ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", var.db_instance.identifier],
      DatabaseConnections       = ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      MaximumUsedTransactionIDs = ["AWS/RDS", "MaximumUsedTransactionIDs", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],

      FreeableMemory   = ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Minimum" }],
      SwapUsage        = ["AWS/RDS", "SwapUsage", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      FreeStorageSpace = ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Minimum" }],

      CPUUtilization           = ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      CPUCreditUsage           = ["AWS/RDS", "CPUCreditUsage", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      CPUCreditBalance         = ["AWS/RDS", "CPUCreditBalance", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Minimum" }],
      CPUSurplusCreditsCharged = ["AWS/RDS", "CPUSurplusCreditsCharged", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      CPUSurplusCreditBalance  = ["AWS/RDS", "CPUSurplusCreditBalance", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Minimum" }],

      WriteThroughput = ["AWS/RDS", "WriteThroughput", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      ReadThroughput  = ["AWS/RDS", "ReadThroughput", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],

      ReadIOPS  = ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      WriteIOPS = ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],

      ReadLatency    = ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      DiskQueueDepth = ["AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],

      TransactionLogsDiskUsage  = ["AWS/RDS", "TransactionLogsDiskUsage", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      TransactionLogsGeneration = ["AWS/RDS", "TransactionLogsGeneration", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      OldestReplicationSlotLag  = ["AWS/RDS", "OldestReplicationSlotLag", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      ReplicationSlotDiskUsage  = ["AWS/RDS", "ReplicationSlotDiskUsage", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],

      NetworkReceiveThroughput  = ["AWS/RDS", "NetworkReceiveThroughput", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
      NetworkTransmitThroughput = ["AWS/RDS", "NetworkTransmitThroughput", "DBInstanceIdentifier", var.db_instance.identifier, { "stat" = "Maximum" }],
    }
  }
}

module "name" {
  source = "../../../modules/widgets/text"

  text    = "RDS: ${var.section_name}"
  details = "Instance: ${var.db_instance.instance_class}; Storage:${var.db_instance.allocated_storage}GB"
}

module "summary" {
  source = "../../../modules/widgets/value"

  name = "RDS Summary: ${var.db_instance.identifier}"
  metrics = [
    local.metrics.rds.DatabaseConnections,
    local.metrics.rds.FreeStorageSpace,
    local.metrics.rds.FreeableMemory,
    local.metrics.rds.SwapUsage,
    local.metrics.rds.CPUUtilization,
    local.metrics.rds.CPUCreditBalance,
  ]

  width = 24
}

module "memory" {
  source = "../../../modules/widgets/value-chart"

  name    = "memory"
  metrics = [local.metrics.rds.FreeableMemory, local.metrics.rds.SwapUsage]
}

module "cpu" {
  source = "../../../modules/widgets/value-chart"

  name    = "cpu"
  metrics = [local.metrics.rds.CPUUtilization]
}

module "storage" {
  source = "../../../modules/widgets/value-chart"

  name    = "storage"
  metrics = [local.metrics.rds.FreeStorageSpace]
}

module "connections" {
  source = "../../../modules/widgets/value-chart"

  name    = "connections"
  metrics = [local.metrics.rds.DatabaseConnections]
}

module "credits" {
  source = "../../../modules/widgets/value-chart"

  name = "credits"
  metrics = [local.metrics.rds.CPUCreditUsage, local.metrics.rds.CPUCreditBalance,
  local.metrics.rds.CPUSurplusCreditsCharged, local.metrics.rds.CPUSurplusCreditBalance]
}

module "read_write" {
  source = "../../../modules/widgets/value-chart"

  name    = "read/write"
  metrics = [local.metrics.rds.ReadIOPS, local.metrics.rds.WriteIOPS]
}

module "network" {
  source = "../../../modules/widgets/value-chart"

  name    = "network"
  metrics = [local.metrics.rds.NetworkReceiveThroughput, local.metrics.rds.NetworkTransmitThroughput]
}
