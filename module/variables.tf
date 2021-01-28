variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "cluster_name" {
  default = null
}

variable "admin_username"{
  type = string
  default = "svc_ansible"
}

variable "workspace_id" {
    description = "Log Analytics Workspace ID"
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {"costCenterID" = "2100238000"}
}


variable "network_plugin" {
  default = "azure"
}

variable "linux_profile" {
  description = "Username and ssh key for accessing AKS Linux nodes with ssh."
  type = object({
    username = string,
    ssh_key  = string
  })
  default = null
}

variable "vm_size_default_node_pool" {
  type = string
  default = "Standard_F2s"
}

variable "nodes_pools" {
  description = "A list of nodes pools to create, each item supports same properties as `local.default_agent_profile`"
  type        = list(any)
  default = null

}

variable "default_node_pool" {
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

variable "environment" {
  description = "Project environment"
  type        = string
  default = ""
}

variable "kubernetes_version" {
  type = string
  default = null
}

variable "vnet_resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}


variable "enable_oms_agent" {
  type = bool
  default = true
}

variable "enable_rbac" {
  type = bool
  default = false
}

variable "container_registry_name" {
  type = string
  default = ""
}

variable "node_count" {
  type = number
  default = 2
}

