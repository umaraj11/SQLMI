terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~>3.2.0"
      configuration_aliases = [azurerm, azurerm.connectivity]
    }
  }
}

data "azurerm_resource_group" "this" {
  for_each = var.resource_groups

  name = each.value.name
}

data "azurerm_network_ddos_protection_plan" "this" {
  provider = azurerm.connectivity

  name                = var.ddos_protection_plan.name
  resource_group_name = var.ddos_protection_plan.resource_group_name
}

resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this[each.value.resource_group_key].name

  address_space = each.value.address_space
  tags          = each.value.tags

  ddos_protection_plan {
    id     = data.azurerm_network_ddos_protection_plan.this.id
    enable = true
  }
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                           = each.value.name
  resource_group_name                            = azurerm_virtual_network.this[each.value.virtual_network_key].resource_group_name
  virtual_network_name                           = azurerm_virtual_network.this[each.value.virtual_network_key].name
  address_prefixes                               = each.value.address_prefixes
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies

  service_endpoints = each.value.service_endpoints

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }
}
