output "widgets" {
  description = "Widgets that can be combined within the dashboard"

  value = concat(
    [module.name.widget],
    module.vcpus.widgets
  )
}
