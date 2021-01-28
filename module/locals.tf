locals {

  aks_name    = "aks-${var.environment}-${var.cluster_name}"


  default_agent_profile = {
    name                    = "default"
    count                   = var.node_count
    vm_size                 = var.vm_size_default_node_pool
    os_type                 = "Linux"
    availability_zones      = [1, 2, 3]
    enable_auto_scaling     = false
    min_count               = null
    max_count               = null
    type                    = "VirtualMachineScaleSets"
    node_taints             = null
    vnet_subnet_id          = data.azurerm_subnet.main.id
    max_pods                = 30
    os_disk_size_gb         = 32
    enable_node_public_ip   = false
    orchestrator_version    = null
    tags                    = var.tags
    location                = data.azurerm_resource_group.main.location
  }

  # Defaults for Linux profile
  # Generally smaller images so can run more pods and require smaller HD
  default_linux_node_profile = {
    max_pods        = 30
    os_disk_size_gb = 60
  }

  # Defaults for Windows profile
  # Do not want to run same number of pods and some images can be quite large
  default_windows_node_profile = {
    max_pods        = 20
    os_disk_size_gb = 200
  }

  default_node_pool = merge(local.default_agent_profile, var.default_node_pool)
  nodes_pools_with_defaults = [for ap in var.nodes_pools : merge(local.default_agent_profile, ap)]
  nodes_pools = [for ap in local.nodes_pools_with_defaults : ap.os_type == "Linux" ? merge(local.default_linux_node_profile, ap) : merge(local.default_windows_node_profile, ap)
  ]


}
