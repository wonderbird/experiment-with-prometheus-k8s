#!/bin/bash
#
# Export the current secrets of the kubernetes cluster to environment variables for terraform.
#
# Usage:
# source export-azure-secrets-to-environment-variables.sh

# The following guide describes how to setup Azure and obtain the secrets from your Azure account
# https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

export TF_VAR_k8s_host=$(terraform output host)
export TF_VAR_k8s_username=$(terraform output username)
export TF_VAR_k8s_password=$(terraform output password)
export TF_VAR_k8s_client_certificate=$(terraform output client_certificate)
export TF_VAR_k8s_client_key=$(terraform output client_key)
export TF_VAR_k8s_cluster_ca_certificate=$(terraform output cluster_ca_certificate)

echo
echo "                  Host = ${TF_VAR_k8s_host}"
echo "              Username = ${TF_VAR_k8s_username}" 
if [ -z "$TF_VAR_k8s_password" ]; then
  echo "              Password is empty"
else
  echo "              Password won't be printed here"
fi
if [ -z "$TF_VAR_k8s_client_certificate" ]; then
  echo "    Client certificate is empty"
else
  echo "    Client certificate won't be printed here"
fi
if [ -z "$TF_VAR_k8s_client_key" ]; then
  echo "            Client key is empty"
else
  echo "            Client key won't be printed here"
fi
if [ -z "$TF_VAR_k8s_cluster_ca_certificate" ]; then
  echo "Cluster CA certificate is empty"
else
  echo "Cluster CA certificate won't be printed here"
fi