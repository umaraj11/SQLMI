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

resource "azurerm_mssql_managed_instance" "this" {
  for_each = var.mssql_managed_instances

  name                         = each.value.name
  resource_group_name          = data.azurerm_resource_group.this[each.value.resource_group_key].name
  location                     = each.value.location
  sku_name                     = each.value.sku_name
  vcores                       = each.value.vcores
  storage_size_in_gb           = each.value.storage_size_in_gb
  subnet_id                    = data.azurerm_subnet.this[each.value.subnet_key].id
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  license_type                 = each.value.license_type
  proxy_override               = each.value.proxy_override
  tags                         = each.value.tags
}

resource "azurerm_mssql_managed_database" "this" {
  for_each = var.mssql_managed_database

  name                = each.value.name
  managed_instance_id = azurerm_mssql_managed_instance.this[each.value.sql_mi_key].id

  depends_on = [
    azurerm_mssql_managed_instance.this
  ]
}


resource "azurerm_private_endpoint" "this" {
  for_each            = var.sql_private_endpoint
  name                = each.value.name
  location            = azurerm_mssql_managed_instance.this[each.value.mssql_managed_instance_key].location
  resource_group_name = data.azurerm_resource_group.this[each.value.resource_group_key].name
  subnet_id           = data.azurerm_subnet.this[each.value.subnet_key].id

  private_service_connection {
    name                           = "pe-sql-eus2-stg"
    private_connection_resource_id = azurerm_mssql_managed_instance.this[each.value.mssql_managed_instance_key].id
    is_manual_connection           = false
    subresource_names              = ["managedInstance"]
  }
  private_dns_zone_group {
    name                 = "sql-pdnszg"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }
}
