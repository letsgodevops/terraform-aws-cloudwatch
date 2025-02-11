variable "section_name" {
  type        = string
  description = "Service display name"
}

variable "db_instance" {
  type = object({
    instance_class    = string
    allocated_storage = number
    identifier        = string
  })
  description = "Direct link to the rds_instance resource"
}
