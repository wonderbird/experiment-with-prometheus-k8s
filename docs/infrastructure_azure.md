# Create a Kubernetes Cluster in Azure

## Prerequisites

### Azure CLI on Local Computer

Follow the [Install Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?view=azure-cli-latest) instructions to install the cli on your computer.

### Azure Account

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

You can create a [free azure account here](https://azure.microsoft.com/en-us/free/).

In order for the setup to work you need to provide valid credentials to the container in the form of environment variables. Please follow the [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) guide in order to obtain the values.

If this is the first time you run these instructions, then copy the file [docs/template-export-azure-secrets-to-environment-variables.sh](template-export-azure-secrets-to-environment-variables.sh) to `infrastructure/export-azure-secrets-to-environment-variables.sh`. Enter the correct environment variable values into the copied file. Then encrypt the file using the command

```sh
gpg --encrypt --armor --recipient vogel@hia.rwth-aachen.de export-azure-secrets-to-environment-variables.sh
rm export-azure-secrets-to-environment-variables.sh
```

**Attention**

Only check the encrypted file into sorce control. Never check in the unencrypted file. A `.gitinore` rule has been set up to prevent this from happening.

## Install Azure Kubernetes Service

Finally, install the Azure Kubernetes Service using terraform:

```sh
# Apply login Credentials for Azure and launch a terraform docker container
cd infrastructure
eval "$(gpg --decrypt export-azure-secrets-to-environment-variables.sh.asc)"

# Apply the configuration of the infrastructure
cd /root/work/infrastructure

# If this is the first time you run terraform in this directory
# then initialize the terraform state
terraform init

# Create or update the k8s infrastructure in azure
terraform apply -auto-approve
```

2. Export the Azure Kubernetes Service configuration from the terraform state into environment variables of the docker container.

```sh
source export-k8s-secrets-to-environment-variables.sh
```

## Access the Kubernetes Dashboard

Follow the instructions on [Azure Portal](https://portal.azure.com) &rarr; Resource groups &rarr; k8srg &rarr; k8s_prod &rarr; View kubernetes dashboard:

```sh
# Execute the following commands directly on your local machine,
# outside the boos/terraform docker container

# If you have not installed azure aks yet, then run the following command
az aks install-cli

# Log into the k8s cluster and forward the dashboard to
# http://localhost:8001
az aks get-credentials --resource-group k8srg --name k8s_prod
az aks browse --resource-group k8srg --name k8s_prod
```

## References

* Microsoft: [Create your Azure free account today](https://azure.microsoft.com/en-us/free/), last visited on Feb. 26, 2020.
* Microsoft: [Azure Portal](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Resources/QuickstartCenterBlade), last visited on Feb. 26, 2020.
* Microsoft: [Install Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?view=azure-cli-latest), last visited on Feb. 26, 2020.
* Microsoft: [Tutorial: Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/de-de/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks), last visited on Feb. 26, 2020.
* Microsoft: [Tutorial: Scale applications in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/de-de/azure/aks/tutorial-kubernetes-scale), last visited on Feb. 26, 2020.
* HashiCorp: [Creating a Kubernetes Cluster with AKS and Terraform](https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform/), last visited on Feb. 26, 2020.
* HashiCorp: [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html), last visited on Feb. 26, 2020.
* Kubernetes: [Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/), last visited on Feb. 26, 2020.
