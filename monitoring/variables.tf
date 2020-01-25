# The variables in here are overwritten by environment variables.
#
# After having terraformed the ../infrastructure, please query the environment variables from
# that directory. Instructions are given in the ../README.md.
#
variable "k8s_host" {
    type = string
    default = "k8s_host is undefined"
}

variable "k8s_username" {
    type = string
    default = "k8s_username is undefined"
}

variable "k8s_password" {
    type = string
    default = "k8s_password is undefined"
}

variable "k8s_client_certificate" {
    type = string
    default = "k8s_client_certificate is undefined"
}

variable "k8s_client_key" {
    type = string
    default = "k8s_client_key is undefined"
}

variable "k8s_cluster_ca_certificate" {
    type = string
    default = "k8s_cluster_ca_certificate is undefined"
}
