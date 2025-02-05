# Dashboard body

This module will create single dashboard with all the widgets inside.


## Example

```
module "dashboard" {
  source = "github.com/letsgodevops/terraform-aws-cloudwatch//modules/dashboards/body"

  name = "my-dashboard"
  widgets = concat(
    module.ecs.monitoring.widgets
    module.rds.monitoring.widgets
  )
}
```
