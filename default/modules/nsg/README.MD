Network Security Group terraform module
===========

This module will deploy the Network security group to filter traffic for the firewall


Module Input Variables
----------------------

- 'resource groups' - the name of the resource group the NSG will be deployed to
- 'network security groups' - the name of the NSG to filter traffic
- 'network security rules' - the rules to define which traffic is allowed


Usage
-----

```hcl
module "nsg" {
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
======

