#!/bin/bash
#
# Export the current secrets of the Azure cluster to environment variables for terraform.
#
# Attention:
# This file contains secrets. With this information a person can create infrastructure
# in Azure. This will produce costs for the Azure account connected to the secrets.
#
# Advice:
# Encrypt this file.
#
# gpg --encrypt --armor --recipient vogel@hia.rwth-aachen.de export-azure-secrets-to-environment-variables.sh
#
# Usage:
# To use the encrypted file in a safe way issue the following command
#
# eval "$(gpg --decrypt export-azure-secrets-to-environment-variables.sh.asc)"

# The following guide describes how to setup Azure and obtain the secrets from your Azure account
# https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

export ARM_CLIENT_ID="<enter-your-id-here>"
export ARM_CLIENT_SECRET="<enter-your-secret-here>"
export ARM_SUBSCRIPTION_ID="<enter-your-id-here>"
export ARM_TENANT_ID="<enter-your-id-here>"
export TF_VAR_client_id=$ARM_CLIENT_ID
export TF_VAR_client_secret=$ARM_CLIENT_SECRET

echo "Secrets have been set in the environment"
echo
echo "      ARM_CLIENT_ID = $ARM_CLIENT_ID"
if [ -z "$ARM_CLIENT_SECRET" ]; then
    echo "  ARM_CLIENT_SECRET is empty"
else
    echo "  ARM_CLIENT_SECRET = <not printed here>"
fi
echo "ARM_SUBSCRIPTION_ID = $ARM_SUBSCRIPTION_ID"
echo "      ARM_TENANT_ID = $ARM_TENANT_ID"

docker run -it --rm --name terra \
           -e "ARM_CLIENT_ID=$ARM_CLIENT_ID" \
           -e "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID" \
           -e "ARM_TENANT_ID=$ARM_TENANT_ID" \
           -e "ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET" \
           -e "TF_VAR_client_id=$TF_VAR_client_id" \
           -e "TF_VAR_client_secret=$TF_VAR_client_secret" \
           -v /Users/stefan/src/experiment-with-prometheus-k8s:/root/work \
           boos/terraform
