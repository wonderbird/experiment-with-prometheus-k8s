provider "kubernetes" {
  host                   = var.k8s_host
  username               = var.k8s_username
  password               = var.k8s_password
  client_certificate     = base64decode(var.k8s_client_certificate)
  client_key             = base64decode(var.k8s_client_key)
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
}

provider "helm" {
  install_tiller = true
  
  kubernetes {
    host                   = var.k8s_host
    username               = var.k8s_username
    password               = var.k8s_password
    client_certificate     = base64decode(var.k8s_client_certificate)
    client_key             = base64decode(var.k8s_client_key)
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  }
}
