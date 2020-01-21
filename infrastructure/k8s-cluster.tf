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

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s_prod.kube_config_raw
}