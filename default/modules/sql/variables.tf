variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default     = {}
  description = "Resource group infrastructure will be deployed to"
}

variable "mssql_managed_instances" {
  type = map(object({
    name                         = string
    location                     = string
    resource_group_key           = string
    sku_name                     = string
    vcores                       = string
    storage_size_in_gb           = string
    subnet_key                   = string
    administrator_login          = string
    administrator_login_password = string
    license_type                 = string
    proxy_override               = string
    tags                         = map(string)
  }))
  default     = {}
  description = "the mssql managed instance"
}

variable "sql_private_endpoint" {
  type = map(object({
    name                       = string
    location                   = string
    resource_group_key         = string
    subnet_key                 = string
    mssql_managed_instance_key = string
    private_dns_zone_id        = string
  }))
  description = "The private endpoint for the redis cache"
  default     = {}
}

variable "mssql_managed_database" {
  type = map(object({
    name       = string
    sql_mi_key = string
  }))
  default     = {}
  description = "The mssql managed database"
}
variable "virtual_networks" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)
    tags               = map(string)
  }))
  default = {}
}

variable "subnets" {
  type = map(object({
    name                = string
    virtual_network_key = string
    address_prefixes    = list(string)
  }))
  default = {}
}
