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

resource "azurerm_route_table" "this" {
  for_each = var.route_tables

  name                = each.value.name
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.this[each.value.resource_group_key].name

  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = {}
}

resource "azurerm_route" "this" {
  for_each = var.routes

  name                   = each.value.name
  resource_group_name    = data.azurerm_resource_group.this[each.value.resource_group_key].name
  route_table_name       = azurerm_route_table.this[each.value.route_table_key].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_ip_address
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.route_table_associations

  subnet_id      = data.azurerm_subnet.this[each.value.subnet_key].id
  route_table_id = azurerm_route_table.this[each.value.route_table_key].id

  timeouts {
    create = "30m"
  }
}
