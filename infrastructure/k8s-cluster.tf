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

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.host}"
  username               = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.username}"
  password               = "${azurerm_kubernetes_cluster.k8s_prod.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s_prod.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example"
    }

    name = "example-namespace"
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx-example"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "example"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_pod.nginx.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
