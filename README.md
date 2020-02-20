# Experiment with Prometheus on Kubernetes

Experimenting with prometheus and its ecosystem while exploring different
hosting services.

This project shows how to run a prometheus server, connect it to grafana and
add blackbox-exporter for scraping metrics.

The software in this project is highly experimental. Its only purpose is for
me to learn about
* prometheus and grafana features,
* integrating them into a kubernetes environment
* which is hosted on azure (for now)
* and deployed using terraform.

## Usage

The terraform scripts in this repositories have been tested both with
kubernetes provided by Docker Desktop running on macOS Catalina and with
Azure Kubernetes Service (AKS).

The following pages show how to prepare a kubernetes cluster in either
hosting environment:

* [Prepare a Kubernetes Cluster in Docker Desktop](docs/infrastructure_docker_desktop.md)
* [Prepare a Kubernetes Cluster in Azure](docs/infrastructure_azure.md) (This file does not exist yet. The documentation is still in this README below.)

After having prepared your kubernetes cluster, proceed to

* [Create Services on any Running Kubernetes Cluster](docs/monitoring.md) (This file does not exist yet. The documentation is still in this README below.)

### Create a Kubernetes Cluster in Azure

1. Create the base infrastructure as described in section "... With Azure CLI Support" of [boos/terraform](https://hub.docker.com/repository/docker/boos/terraform)

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

2. Export the infrastructure configuration from the terraform state into environment variables of the docker container

```sh
source export-k8s-secrets-to-environment-variables.sh
```

### Create Services on Kubernetes

```sh
cd /root/work/monitoring

# If running a Kubernetes Cluster on Docker Desktop locally
cp k8s-and-helm-docker-desktop k8s-and-helm.tf

# If running a Kubernetes Cluster on Azure
cp k8s-and-helm-azure k8s-and-helm.tf

# If this is the first time you run terraform in this directory
# then initialize the terraform state
terraform init

# Create or update the service in kubernetes
terraform apply -auto-approve
```

## Inspect the Infrastructure

### Azure: Access the Kubernetes Dashboard

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

## Access Prometheus and Grafana

Once the system is running you can...

* To view Prometheus on http://localhost:9090/ forward its port by `kubectl port-forward -n monitoring  prometheus-prometheus-operator-prometheus-0 9090:9090`
* To view Grafana on http://localhost:3000/ forward its port by `kubectl port-forward -n monitoring svc/prometheus-operator-grafana 3000:80`

## Cleanup and Destroy the Infrastructure

### Destroy the Deployment Inside Kubernetes

```sh
cd /root/work/monitoring

terraform destroy -auto-approve
```

### Azure: Destroy the Kubernetes Cluster Itself

```sh
cd /root/work/infrastructure

terraform destroy -auto-approve
```

## Remarks and Tools

### Debug the prometheus.yaml Configuration Used by the Prometheus-Operator

The prometheus pod can be identified in the kubernetes dashboard by its name `prometheus-prom-operator-prometheus-o-prometheus-0`. When it is started, the prometheus configuration taken from the kubernetes secret `prometheus-prom-operator-prometheus-o-prometheus`. The secret contains the final prometheus configuration after `helm` has interpolated all its commandline arguments and parameter files. To inspect this final configuration, get the secret, decode it from base64 and then unzip it:

```sh
kubectl get secret prometheus-prom-operator-prometheus-o-prometheus -o yaml | grep prometheus.yaml.gz | awk '{print $2}' | base64 --decode | gzip -dc > actual_prometheus.yaml
```

## Next Steps

### Have prometheus scrape the blackbox exporter endpoint

### Establish Security

* Remove redundant values from the *-values.yaml files. "redundant" means: values which have just been copy-pasted from the values.yaml file of the original helm chart.
* [Securing your Helm Installation](https://v2.helm.sh/docs/using_helm/#securing-your-helm-installation)

### Resolve Code Smells

* Set resource constraints in the kubernetes pod configurations (min/max values, pod restart rules)

## References

### Primary Inspriation

* Hasham Haider: [Kubernetes in Production: The Ultimate Guide to Monitoring Resource Metrics with Prometheus](https://www.replex.io/blog/kubernetes-in-production-the-ultimate-guide-to-monitoring-resource-metrics), last visited on Jan. 23, 2020

### Terraform Practices

* HashiCorp: [Getting Started with Kubernetes provider](https://www.terraform.io/docs/providers/kubernetes/guides/getting-started.html), last visited on Jan. 21, 2020
* HashiCorp: [Terraform Recommended Practices - Part 1: An Overview of Our Recommended Workflow](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html), last visited on Jan. 22, 2020
* HashiCorp: [Using the Kubernetes and Helm Providers with Terraform 0.12](https://www.hashicorp.com/blog/using-the-kubernetes-and-helm-providers-with-terraform-0-12/), last visited on Jan. 23, 2020

### Cloud Provider Specific Instructions

* Microsoft: [Create your Azure free account today](https://azure.microsoft.com/en-us/free/), last visited on Jan. 21, 2020
* Microsoft: [Tutorial: Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/de-de/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks), last visited on Jan. 21, 2020
* HashiCorp: [Creating a Kubernetes Cluster with AKS and Terraform](https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform/), last visited on Jan. 21, 2020
* HashiCorp: [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html), last visited on Jan. 21, 2020.
* Microsoft: [Tutorial: Scale applications in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/de-de/azure/aks/tutorial-kubernetes-scale), last visited on Jan. 23, 2020

### Prometheus and Grafana

* The Prometheus Authors: [Prometheus - Monitoring system & time series database](https://prometheus.io), last visited on Jan. 21, 2020
* The Prometheus Authors: [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter), last visited on Jan. 21, 2020
* Joshua Barrat: [jbarratt/prometheus_sitemon](https://github.com/jbarratt/prometheus_sitemon), last visited on Jan. 21, 2020
* Grafana Labs: [Grafana: The open observability platform](https://grafana.com), last visited on Jan. 21, 2020

### Other Stuff

* Ajeet Singh Raina: [5 Minutes to Kubernetes Dashboard running on Docker Desktop for Windows 2.0.0.3](http://collabnix.com/kubernetes-dashboard-on-docker-desktop-for-windows-2-0-0-3-in-2-minutes/), last visited on Jan. 30, 2020
* The Kubernetes Dashboard Authors: [kubernetes/dashboard: General-purpose web UI for Kubernetes clusters](https://github.com/kubernetes/dashboard), last visited on Jan. 30, 2020
* The Kubernetes Authors: [Resource metrics pipeline - Kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/), last visited on Jan. 23, 2020
* Stefan Boos: [boos/terraform](https://hub.docker.com/repository/docker/boos/terraform), last visited on Jan. 21, 2020
