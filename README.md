# Criação de Cluster AKS com Nodepool Spot


# Variáveis obrigatórias / Como usar
module "modules" {

    source = "./modules"

    rg_name                     = "Resource Group do Cluster"
    cluster_name                = "Nome do cluster"
    client_id                   = "Service principal ID"
    client_secret               = "Sevice principal Pass"
    log_workspace_id            = "id_do_log_workspace" Azure Log Workspace
    analytics_workspace_name    = "workspace_analytics_nome"
    vnet_rg_name                = "resource_group_vnet"
    vnet_name                   = "nome_da_vnet"
    subnet_name                 = "Nome_da_subnet"
    nodes_spot                  = "True ou False"
}

#Varáveis Opcionais e valores padrão

        var.cluster_name        = "aks_cluster" 
        var.location            = "East US 2" 
        var.username            = svc_ansible
        var.prefix              = "aks-dns"
        var.tags                = {"costCenterID" = "00000"}
        var.max_count           = 1
        var.min_count           = 1
        var.admin_user          = "admin"
        var.pool_name           = "nodepool"
        var.spot_pool_name      = "spotpool"
        var.node_count          = "1"
        var.vm_size_spot        = "Standard_F4s"
        var.vm_size_node        = "Standard_F2s"
        var.nodepool_priority   = "Spot"
        var.vnet_rg_name        = "LAB_Networks"
        var.node_os             = "linux"
        var.auto_scaling        = true
        var.eviction_policy     = "Delete"
        var.spot_max_price      = "-1"
        var.enable_oms_agent    = true
        var.enable_rbac         = true
        var.kubernetes_version  = default = "1.18.10"
        var.node_labels         = "kubernetes.azure.com/scalesetpriority" = "spot"} *Muito importante para que os microserviços consigam usar nodes do      tipo spot* 
        var.network_plugin      = "azure"

# Default node  pool
    name                    = "default"
    count                   = 1
    vm_size                 = var.vm_size_default_node_pool"
    os_type                 = "Linux"
    availability_zones      = [1, 2, 3]
    enable_auto_scaling     = false
    min_count               = null
    max_count               = null
    type                    = "VirtualMachineScaleSets"
    node_taints             = null
    vnet_subnet_id          = var.nodes_subnet_id
    max_pods                = 30
    os_disk_size_gb         = 32
    enable_node_public_ip   = false
    orchestrator_version    = var.kubernetes_version
    location                = "eastus2"

# Node pools

  count                 "Neste campo é realizado o search do conteudo dibamico para a criação dos node pools, onde os campos abaixo são alimentados pelos indices criados no tfvars no objeto node pools"
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
  priority              = local.nodes_pools[count.index].priority
  eviction_policy       = local.nodes_pools[count.index].eviction_policy
  spot_max_price        = local.nodes_pools[count.index].spot_max_price
  
Ex:
nodes_pools = [
    {
     name                = "pool1"
      count               = 2 # definie a quantidade de nodes no cluster
      vm_size             = "Standard_D1_v2"
      os_type             = "Linux"
      os_disk_size_gb     = 30
      availability_zones  = ["1", "2", "3"]
      orchestrator_version = "1.18.10"
      priority            = null
      spot_max_price      = null
      eviction_policy     = null
      location            = "eastus2"
    }
  ]
#Caso seja necesário a criação de node pools do tipo spot deve se adicionar os valores nos campos:

      priority            = null
      spot_max_price      = null
      eviction_policy     = null


nodes_pools = [
    {
     name                = "pool1"
      count               = 2
      vm_size             = "Standard_D1_v2"
      os_type             = "Linux"
      os_disk_size_gb     = 30
      availability_zones  = ["1", "2", "3"]
      orchestrator_version = "1.18.10"
      priority            = "Spot"
      spot_max_price      = -1
      eviction_policy     = Delete
      location            = "eastus2"
    }
  ]

  Exemplo Multiplos node pools:

nodes_pools = [
    {
     name                = "pool1"
      count               = 2
      vm_size             = "Standard_D1_v2"
      os_type             = "Linux"
      os_disk_size_gb     = 30
      availability_zones  = ["1", "2", "3"]
      orchestrator_version = "1.18.10"
      priority            = null
      spot_max_price      = null
      eviction_policy     = null
      location            = "eastus2"
    },
    {
     name                = "pool2"
      count               = 2
      vm_size             = "Standard_D1_v2"
      os_type             = "Linux"
      os_disk_size_gb     = 30
      availability_zones  = ["1", "2", "3"]
      orchestrator_version = "1.18.10"
      priority            = "Spot"
      spot_max_price      = -1
      eviction_policy     = Delete
      location            = "eastus2"
    }

  ]

#

# Validação e testes
Executar: terraform apply ou terraform apply -out <caminho_do_arquivo_output>

# Contribuições:



