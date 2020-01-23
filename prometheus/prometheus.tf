resource "kubernetes_pod" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      App = "prometheus"
    }
  }

  spec {
    container {
      image = "prom/prometheus:latest"
      name  = "prometheus"

      port {
        container_port = 9090
      }
    }
  }
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_pod.prometheus.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 9090
    }

    type = "LoadBalancer"
  }
}
