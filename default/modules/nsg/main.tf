data "azurerm_resource_group" "this" {
  for_each = var.resource_groups

  name = each.value.name
}
data "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this[each.value.resource_group_key].name
}

data "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.value.name
  virtual_network_name = data.azurerm_virtual_network.this[each.value.virtual_network_key].name
  resource_group_name  = data.azurerm_resource_group.this[each.value.virtual_network_key].name
}

resource "azurerm_network_security_group" "this" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this[each.value.resource_group_key].name
  tags                = each.value.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.network_security_rules

  resource_group_name          = azurerm_network_security_group.this[each.value.network_security_group_key].resource_group_name
  network_security_group_name  = azurerm_network_security_group.this[each.value.network_security_group_key].name
  name                         = each.value.name
  description                  = lookup(each.value, "description", null)
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = lookup(each.value, "source_port_range", null)
  source_port_ranges           = lookup(each.value, "source_port_ranges", null)
  source_address_prefix        = lookup(each.value, "source_address_prefix", null)
  source_address_prefixes      = lookup(each.value, "source_address_prefixes", null)
  destination_port_range       = lookup(each.value, "destination_port_range", null)
  destination_port_ranges      = lookup(each.value, "destination_port_ranges", null)
  destination_address_prefix   = lookup(each.value, "destination_address_prefix", null)
  destination_address_prefixes = lookup(each.value, "value.destination_address_prefixes", null)
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnet_network_security_group_associations

  subnet_id                 = data.azurerm_subnet.this[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.this[each.value.network_security_group_key].id
}
