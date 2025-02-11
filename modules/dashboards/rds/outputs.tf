output "widgets" {
  value = concat(
    [
      module.name.widget,
      module.summary.widget
    ],
    module.memory.widgets,
    module.cpu.widgets,
    module.storage.widgets,
    module.connections.widgets,
    module.credits.widgets,
    module.read_write.widgets,
    module.network.widgets
  )
}
