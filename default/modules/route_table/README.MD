Route table terraform module
===========

This module will deploy a route table for the azure firewall


Module Input Variables
----------------------

- 'resource groups' - the name of the resource group the route table will be deployed to
- 'virtual networks' - the name of the virtual network the route table will use
- 'subnets' - subnets for the route table
- 'route tables' - name of the route table
- 'route table associations' - associates route table with a subnet within a vnet



Usage
-----

```hcl
module "route_table" {
  source = "github.com/PaymentFusion/co-infra-bofa-connect-vpn/"

  tags {
    "Environment" = "${var.environment}"
    "Infrastructure_version" = "${var.infrastructure_version}"
    "Owner" = "${var.owner}"
    "Service" = $(var.service)"

  }
}

```
Outputs
====

