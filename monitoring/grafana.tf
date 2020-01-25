resource "kubernetes_pod" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      App = "grafana"
    }
  }

  spec {
    container {
      image = "grafana/grafana:latest"
      name  = "grafana"

      port {
        container_port = 3000
      }
    }
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_pod.grafana.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
