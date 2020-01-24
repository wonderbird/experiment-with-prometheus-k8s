resource "helm_release" "prometheus_operator" {
  name      = "prometheus-operator"
  chart     = "stable/prometheus-operator"
  namespace = "monitoring"
}
