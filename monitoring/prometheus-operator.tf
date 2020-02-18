resource "helm_release" "prometheus_operator" {
  name      = "prometheus-operator"
  chart     = "stable/prometheus-operator"
  namespace = "monitoring"
  version   = "6.7.3"

    values = [
    "${file("prometheus-operator-values.yaml")}"
  ]
}
