# Create Services on Kubernetes

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

## Access Prometheus and Grafana

Once the system is running, use the following commands on your local computer to view Prometheus and Grafana:

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
