resource "helm_release" "blackbox_exporter" {
  name      = "blackbox-exporter"
  chart     = "stable/prometheus-blackbox-exporter"
  namespace = "monitoring"

  values = [
    "${file("blackbox-exporter-values.yaml")}"
  ]
}
