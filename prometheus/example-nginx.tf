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
output "lb_ip" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].ip
}

output "lb_host" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].hostname
}
