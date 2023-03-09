locals {
  tags = {
    service                = var.service
    environment            = var.environment
    owner                  = var.owner
    infrastructure_version = var.infrastructure_version
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.2.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}

module "resource_group" {
  source = "./modules/resource_group"

  resource_groups = var.resource_groups
}

module "networking" {
  source = "./modules/networking"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  resource_groups      = var.resource_groups
  virtual_networks     = var.virtual_networks
  subnets              = var.subnets
  ddos_protection_plan = var.ddos_protection_plan

  depends_on = [
    module.resource_group
  ]
}

module "route_table" {
  source = "./modules/route_table"

  resource_groups          = var.resource_groups
  route_tables             = var.route_tables
  virtual_networks         = var.virtual_networks
  routes                   = var.routes
  subnets                  = var.subnets
  route_table_associations = var.route_table_associations

  depends_on = [
    module.networking
  ]
}

module "nsg" {
  source = "./modules/nsg"

  resource_groups                            = var.resource_groups
  network_security_groups                    = var.network_security_groups
  virtual_networks                           = var.virtual_networks
  subnets                                    = var.subnets
  subnet_network_security_group_associations = var.subnet_network_security_group_associations

  depends_on = [
    module.networking
  ]
}

module "sql" {
  source = "./modules/sql"

  resource_groups         = var.resource_groups
  virtual_networks        = var.virtual_networks
  subnets                 = var.subnets
  mssql_managed_instances = var.mssql_managed_instances
  mssql_managed_database  = var.mssql_managed_database

  depends_on = [
    module.route_table,
    module.nsg
  ]
}
