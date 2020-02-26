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
* [Prepare a Kubernetes Cluster in Azure](docs/infrastructure_azure.md)

After having prepared your kubernetes cluster, proceed to

* [Create Services on any Running Kubernetes Cluster](docs/monitoring.md)

## Remarks and Tools

### Debug the prometheus.yaml Configuration Used by the Prometheus-Operator

The prometheus pod can be identified in the kubernetes dashboard by its name `prometheus-prom-operator-prometheus-o-prometheus-0`. When it is started, the prometheus configuration taken from the kubernetes secret `prometheus-prom-operator-prometheus-o-prometheus`. The secret contains the final prometheus configuration after `helm` has interpolated all its commandline arguments and parameter files. To inspect this final configuration, get the secret, decode it from base64 and then unzip it:

```sh
kubectl get secret prometheus-prom-operator-prometheus-o-prometheus -o yaml | grep prometheus.yaml.gz | awk '{print $2}' | base64 --decode | gzip -dc > actual_prometheus.yaml
```

## Next Steps

### Have prometheus scrape the blackbox exporter endpoint using a ServiceMonitor

Double check whether blackbox probing has made it into Prometheus in the mean time: [Github: **WIP** BlackboxMonitor #2832](https://github.com/coreos/prometheus-operator/pull/2832).

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
