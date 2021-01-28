#Global variables

variable "tenant_id" {
  type = string
  default = null
}

variable "client_id" {
  type = string
  default = null
}

variable "client_secret" {
  type = string
  default = null
}

variable "resource_group_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
}

variable "location" {
  type = string
}

# WORKSPACE vars

variable "analytics_workspace_name" {
    type = string
}

variable "analytics_workspace_sku" {
    type = string
}

variable "analytics_workspace_retention_in_days" {
    type = number
}

variable "analytics_workspace_tags" {
  type = map
}


# AKS variables

variable "aks_cluster_name" {
  type = string
}

variable "aks_vnet_resource_group_name" {
  type = string
}

variable "aks_kubernetes_version" {
  type        = string
}

variable "aks_vnet_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_tags" {
  type = map
}

# variable "aks_nodes_regular" {
#   type    = bool
#   default = false
# }

variable "aks_default_node_pool" {
  description = <<EOD
Default node pool configuration:
```
map(object({
    name                  = string
    count                 = number
    vm_size               = string
    os_type               = string
    availability_zones    = list(number)
    enable_auto_scaling   = bool
    min_count             = number
    max_count             = number
    type                  = string
    node_taints           = list(string)
    vnet_subnet_id        = string
    max_pods              = number
    os_disk_size_gb       = number
    enable_node_public_ip = bool
}))
```
EOD

  type    = map(any)
  default = {}
}

variable "aks_admin_username"{
  type = string
  default = "svc_ansible"
}

variable "aks_nodes_pools" {
  description = "A list of nodes pools to create, each item supports same properties as `local.default_agent_profile`"
  type = list(any)
  default = null
}


variable "node_count" {
  type = number
}

variable "vm_size_default_node_pool" {
  type = string
  default = "Standard_F2s"
}

variable "container_registry_name" {
  type = string
  default = "/subscriptions/0000000-0000-0000-0000-000000000000/resourceGroups/LAB_DEVOPS/providers/Microsoft.ContainerRegistry/registries/LabRegistry"
}