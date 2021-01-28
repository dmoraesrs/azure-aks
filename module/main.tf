data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subnet" "main" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                              = local.aks_name
  location                          = data.azurerm_resource_group.main.location
  dns_prefix                        = replace(local.aks_name, "-", "")
  resource_group_name               = var.resource_group_name
  kubernetes_version                = var.kubernetes_version
  tags                              = var.tags


  default_node_pool {
      name                  = local.default_node_pool.name
      node_count            = local.default_node_pool.count
      vm_size               = local.default_node_pool.vm_size
      availability_zones    = local.default_node_pool.availability_zones
      enable_auto_scaling   = local.default_node_pool.enable_auto_scaling
      min_count             = local.default_node_pool.min_count
      max_count             = local.default_node_pool.max_count
      max_pods              = local.default_node_pool.max_pods
      os_disk_size_gb       = local.default_node_pool.os_disk_size_gb
      type                  = local.default_node_pool.type
      vnet_subnet_id        = local.default_node_pool.vnet_subnet_id
      node_taints           = local.default_node_pool.node_taints
      orchestrator_version  = local.default_node_pool.orchestrator_version
      tags                  = local.default_node_pool.tags
    }




  addon_profile {
    kube_dashboard {
      enabled     = true
    }
    oms_agent {
      enabled                           = var.enable_oms_agent
      log_analytics_workspace_id        = var.workspace_id
    }

  }

  network_profile {
    network_plugin     = var.network_plugin
  }

  role_based_access_control {
    enabled     = var.enable_rbac
  }

  identity {
    type = "SystemAssigned"
  }

}
resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  count                 = length(local.nodes_pools)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  name                  = local.nodes_pools[count.index].name
  vm_size               = local.nodes_pools[count.index].vm_size
  os_type               = local.nodes_pools[count.index].os_type
  os_disk_size_gb       = local.nodes_pools[count.index].os_disk_size_gb
  vnet_subnet_id        = local.nodes_pools[count.index].vnet_subnet_id
  enable_auto_scaling   = local.nodes_pools[count.index].enable_auto_scaling
  node_count            = local.nodes_pools[count.index].count
  min_count             = local.nodes_pools[count.index].min_count
  max_count             = local.nodes_pools[count.index].max_count
  enable_node_public_ip = local.nodes_pools[count.index].enable_node_public_ip
  availability_zones    = local.nodes_pools[count.index].availability_zones
  orchestrator_version  = local.nodes_pools[count.index].orchestrator_version
  tags                  = local.nodes_pools[count.index].tags
  #
  priority              = local.nodes_pools[count.index].priority
  eviction_policy       = local.nodes_pools[count.index].eviction_policy
  spot_max_price        = local.nodes_pools[count.index].spot_max_price

}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = local.default_node_pool.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}

resource "azurerm_role_assignment" "acr" {
  scope                = var.container_registry_name
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}