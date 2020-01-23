output "prometheus_ip" {
  value = kubernetes_service.prometheus.load_balancer_ingress[0].ip
}

output "grafana_ip" {
  value = kubernetes_service.grafana.load_balancer_ingress[0].ip
}
