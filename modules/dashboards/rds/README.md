# RDS Dashboard

Provides basic metrics for RDS instance
Those include:
* Summary of instance size & storage
* CPU, Memory, Storage utilization
* Active connections 
* IOPS and Network statistics

## Example
```
module "dashboard" {
  source = "github.com/letsgodevops/terraform-aws-cloudwatch//modules/dashboards/rds"

  section_name = "My database"
  db_instance  = aws_db_instance.this
}
```


## Preview
![Preview](./preview.png) 
