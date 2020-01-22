#####
# At the moment the following outputs are not needed.
#

#output "kube_config" {
#  value = azurerm_kubernetes_cluster.k8s_prod.kube_config_raw
#}

# End of unnecessary outputs
#####

output "host" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.host
}

output "username" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.username
}

output "password" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.password
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_certificate
}

output "client_key" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.client_key
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.k8s_prod.kube_config.0.cluster_ca_certificate
}
