# Experiment with Prometheus on Azure Kubernetes Service (AKS)

Experimenting with prometheus and its ecosystem hosted on azure kubernetes service (aks).

This project shows how to run a prometheus server, connect it to grafana and add some services for scraping metrics.

The software in this project is highly experimental. Its only purpose is for me to learn about prometheus and grafana features and integrating them into a docker-compose / kubernetes environment which is hosted on azure.

## Usage

Create the base infrastructure as described in section "... With Azure CLI Support" of [boos/terraform](https://hub.docker.com/repository/docker/boos/terraform)

```sh
# To apply a modified configuration of the infrastructure quickly, execute
# the following commands in the boos/terraform docker container
cd /root/work/infrastructure

terraform apply -auto-approve -var client_id="$ARM_CLIENT_ID" -var client_secret="$ARM_CLIENT_SECRET"
```

## Inspect the Infrastructure

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

## Outlook

(This repo is not there yet. Next step: Find out how to separate the persistent infrastructure from team owned k8s deployments - inspiration: https://www.terraform.io/docs/state/workspaces.html)

Once the system is running you can...

* Connect to Prometheus on http://localhost:9090
  * In Prometheus you can view all the names of all scraped metrics
* Connect to Grafana on http://localhost:3000 (username "admin" and password "admin")
  * In Grafana you can add a new data source and select "Prometheus". The URL is "http://prometheus:9090".
* Enter the ubuntu-analysis-helper container to query the other containers in the network:
  * `docker exec -it ubuntu-analysis-helper /bin/bash`
  * `root@...:/# curl sample-metrics-generator/metrics`
* Modify the `sample-metrics-generator` source code. Then rebuild an restart only that container by typing
  `docker-compose up -d --no-deps --build sample-metrics-generator`

## References

* HashiCorp: [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html), last visited on Jan. 21, 2020.
* Microsoft: [Create your Azure free account today](https://azure.microsoft.com/en-us/free/), last visited on Jan. 21, 2020
* Microsoft: [Tutorial: Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/de-de/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks), last visited on Jan. 21, 2020
* HashiCorp: [Creating a Kubernetes Cluster with AKS and Terraform](https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform/), last visited on Jan. 21, 2020
* HashiCorp: [Getting Started with Kubernetes provider](https://www.terraform.io/docs/providers/kubernetes/guides/getting-started.html), last visited on Jan. 21, 2020
* HashiCorp: [Terraform Recommended Practices - Part 1: An Overview of Our Recommended Workflow](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html), last visited on Jan. 22, 2020
* Prometheus Authors: [Prometheus - Monitoring system & time series database](https://prometheus.io), last visited on Jan. 21, 2020
* Prometheus Authors: [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter), last visited on Jan. 21, 2020
* Grafana Labs: [Grafana: The open observability platform](https://grafana.com), last visited on Jan. 21, 2020
* Joshua Barrat: [jbarratt/prometheus_sitemon](https://github.com/jbarratt/prometheus_sitemon), last visited on Jan. 21, 2020
* Stefan Boos: [boos/terraform](https://hub.docker.com/repository/docker/boos/terraform), last visited on Jan. 21, 2020
