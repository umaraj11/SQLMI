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
  description = "the address of the subnet to be deployed to"
}

variable "ddos_protection_plan" {
  type = object({
    name                = string
    resource_group_name = string
  })
}