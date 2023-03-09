Networking terraform module
===========

This module will deploy a virtual network and attached subnet to host the firewall

Module Input Variables
----------------------

- 'resource groups' - the name of the resource group the VNET
- 'virtual networks' - the name of the virtual network to host the firewall
- 'subnets' - attached subnet for the firewall


Usage
-----

```hcl
module "networking" {
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
=====

