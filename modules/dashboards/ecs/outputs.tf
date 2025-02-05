output "widgets" {
  value = concat(
    [
      module.name.widget,
      module.ecs_container_insights.widget,
    ],
    module.ecs_usage.widgets,
    module.ecs_tesks.widgets,
    module.alb_summary.*.widget,
    module.alb_rq_count.*.widget,
    module.alb_response_time.*.widget,
    module.alb_response.*.widget
  )
}
