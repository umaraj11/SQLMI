infrastructure_version = "v2"
owner                  = "user@axiamed.com"
service                = "service-name"

resource_groups = {
  primary_sql = {
    name     = "rg-%project%-%primary_location_abbreviated%-%env%%branch%"
    location = "%primary_location%"
    tags     = {}
  }
}

virtual_networks = {
  primary_sql = {
    name               = "vnet-%project%-%primary_location_abbreviated%-%env%"
    location           = "%primary_location%"
    resource_group_key = "primary_sql"
    address_space      = ["%primary_sql_address_space%"]
    tags               = {}
  }
}

subnets = {
  primary_sql = {
    name                                           = "SqlMISubnet"
    virtual_network_key                            = "primary_sql"
    address_prefixes                               = ["%primary_sql_prefix%"]
    enforce_private_link_endpoint_network_policies = true
    service_endpoints                              = ["Microsoft.Sql"]
    delegation = [
      {
        name = "delegation"
        service_delegation = [
          {
            name    = "Microsoft.Sql/managedInstances"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
          }
        ]
      }
    ]
  }
}

route_tables = {
  primary_sql = {
    name                          = "rt-%project%-sql-%primary_location_abbreviated%-%env%-1"
    location                      = "%primary_location%"
    resource_group_key            = "primary_sql"
    disable_bgp_route_propagation = false
    tags                          = {}
  }
}

routes = {
  to_firewall = {
    name                = "route-%project%-sql-%primary_location_abbreviated%-%env%"
    resource_group_key  = "primary_sql"
    route_table_key     = "primary_sql"
    address_prefix      = "%bastion_ops_address_space%"
    next_hop_type       = "VirtualAppliance"
    next_hop_ip_address = "%primary_fw_address_space%"
  }
}

route_table_associations = {
  primary_sql = {
    route_table_key = "primary_sql"
    subnet_key      = "primary_sql"
  }
}

network_security_groups = {
  primary_sql = {
    name               = "nsg-%project%-sql-%primary_location_abbreviated%-%env%"
    location           = "%primary_location%"
    resource_group_key = "primary_sql"
    tags               = {}
  }
}

subnet_network_security_group_associations = {
  primary_sql = {
    subnet_key                 = "primary_sql"
    network_security_group_key = "primary_sql"
  }
}

mssql_managed_instances = {
  primary_sql = {
    name                         = "mssql-%project%-%primary_location_abbreviated%-%env%%branch%"
    location                     = "%primary_location%"
    resource_group_key           = "primary_sql"
    subnet_key                   = "primary_sql"
    sku_name                     = "GP_Gen5"
    vcores                       = 24
    storage_size_in_gb           = 256
    administrator_login          = "bofa-azure"
    administrator_login_password = "Azjohndoe99"
    license_type                 = "BasePrice"
    proxy_override               = "Redirect"
    ssl_enforcement              = true
    tags                         = {}
  }
}

mssql_managed_database = {
  Gateway = {
    name       = "Payment-Gateway_TestDB"
    sql_mi_key = "primary_sql"
  }
}

ddos_protection_plan = {
  name                = "ddos-sec-%primary_location_abbreviated%-%connectivity_env%"
  resource_group_name = "rg-sec-%primary_location_abbreviated%-%connectivity_env%"
}
