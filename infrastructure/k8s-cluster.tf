resource "azurerm_kubernetes_cluster" "k8s_prod" {
  name                = "k8s_prod"
  location            = azurerm_resource_group.k8s_resources.location
  resource_group_name = azurerm_resource_group.k8s_resources.name
  dns_prefix          = "sboos-k8s-prod"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  addon_profile {
      kube_dashboard {
          enabled = true
      }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}

# The kubernetes configuration is required so that we are able to setup,
# modify or delete core infrastructure
provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.host}"
  username               = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.username}"
  password               = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.cluster_ca_certificate)}"
}
