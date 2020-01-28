resource "helm_release" "prometheus_operator" {
  name      = "prometheus-operator"
  chart     = "stable/prometheus-operator"
  namespace = "monitoring"
  version   = "6.7.3"

#  set {
#    name = "prometheus.prometheusSpec.additionalScrapeConfigs"
#    value = file("prometheus-operator-values.yaml")
#  }
}
