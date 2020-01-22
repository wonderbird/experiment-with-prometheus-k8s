output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s_prod.kube_config_raw
}

output "lb_ip" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].ip
}

output "lb_host" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].hostname
}
