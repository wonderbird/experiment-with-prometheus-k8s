resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      liveness_probe {
        http_get {
          path = "/nginx_status"
          port = 80
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }
  }
}
