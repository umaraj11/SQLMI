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
