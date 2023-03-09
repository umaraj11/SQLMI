variable "environment" {
  description = "Environment being deployed"
}

variable "service" {
  description = "Name of the service"
}

variable "owner" {
  description = "Name of who owns the project"
}

variable "infrastructure_version" {
  description = "Used in tags to track infrastructure versions"
}

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default     = {}
  description = "Resource group infrastructure will be deployed to"
}

variable "virtual_networks" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)
    tags               = map(string)
  }))
  default     = {}
  description = "The virtual networks that will host the infrastructure"
}

variable "subnets" {
  type = map(object({
    name                                           = string
    virtual_network_key                            = string
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = bool
    service_endpoints                              = list(string)

    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default     = {}
  description = "the address of the subnet to be deployed"
}

variable "route_tables" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    disable_bgp_route_propagation = bool
    tags                          = map(string)
  }))
  default     = {}
  description = "the route table to be deployed"
}

variable "routes" {
  type = map(object({
    name                = string
    resource_group_key  = string
    route_table_key     = string
    address_prefix      = string
    next_hop_type       = string
    next_hop_ip_address = string
  }))
  default     = {}
  description = "the routes to be deployed"
}

variable "route_table_associations" {
  type = map(object({
    route_table_key = string
    subnet_key      = string
  }))
  default     = {}
  description = "will associate the route table with the subnet within a virtual network"
}

variable "network_security_groups" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    tags               = map(string)
  }))
  default     = {}
  description = "the network security groups that will filter traffic"
}

variable "network_security_rules" {
  type = map(object({
    network_security_group_key   = string
    name                         = string
    description                  = string
    priority                     = string
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = string
    source_port_ranges           = list(string)
    source_address_prefix        = string
    source_address_prefixes      = list(string)
    destination_port_range       = string
    destination_port_ranges      = list(string)
    destination_address_prefix   = string
    destination_address_prefixes = list(string)
  }))
  default     = {}
  description = "the rules to define what traffic is allowed, blocked etc."
}

variable "subnet_network_security_group_associations" {
  type = map(object({
    subnet_key                 = string
    network_security_group_key = string
  }))
  default     = {}
  description = "The subnet network security group associations"
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

variable "mssql_managed_database" {
  type = map(object({
    name       = string
    sql_mi_key = string
  }))
  default     = {}
  description = "The mssql managed database"
}

variable "ddos_protection_plan" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "connectivity_subscription_id" {
  type = string
}
