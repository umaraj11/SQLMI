variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default     = {}
  description = "Resource group infrastructure will be deployed to"
}

variable "network_interfaces" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_key            = string
    ip_configuration_name         = string
    subnet_key                    = string
    private_ip_address_allocation = string
  }))
  default = {}
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

variable "network_interface_security_group_associations" {
  type = map(object({
    network_interface_key      = string
    network_security_group_key = string
  }))
  default     = {}
  description = "The network interface security group associations"
}

variable "subnet_network_security_group_associations" {
  type = map(object({
    subnet_key                 = string
    network_security_group_key = string
  }))
  default     = {}
  description = "The subnet network security group associations"
}
