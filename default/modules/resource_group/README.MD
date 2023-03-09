Resource group terraform module
===========

This module will deploy the resource group that will host the firewall


Module Input Variables
----------------------

- 'resource groups' - the name of the resource group the NIC will be deployed to


Usage
-----

```hcl
module "resource_group" {
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

