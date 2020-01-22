provider "kubernetes" {
  host                   = var.k8s_host
  username               = var.k8s_username
  password               = var.k8s_password
  client_certificate     = "${base64decode(var.k8s_client_certificate)}"
  client_key             = "${base64decode(var.k8s_client_key)}"
  cluster_ca_certificate = "${base64decode(var.k8s_cluster_ca_certificate)}"
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
