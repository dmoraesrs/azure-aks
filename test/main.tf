module "aks_cluster" {

  source                     = "../module"

  resource_group_name        = var.resource_group_name
  environment                = var.environment
  cluster_name               = var.aks_cluster_name
  vnet_resource_group_name   = var.aks_vnet_resource_group_name
  vnet_name                  = var.aks_vnet_name
  subnet_name                = var.aks_subnet_name
  tags                       = var.aks_tags
  nodes_pools                = var.aks_nodes_pools
  kubernetes_version         = var.aks_kubernetes_version
  workspace_id               = module.analytics_workspace.resource_id
  node_count                 = var.node_count
  vm_size_default_node_pool  = var.vm_size_default_node_pool
}
