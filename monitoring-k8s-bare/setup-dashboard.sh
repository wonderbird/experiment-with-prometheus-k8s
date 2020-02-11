#!/bin/bash
#
# Install the k8s dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc2/aio/deploy/recommended.yaml
TOKEN=$(kubectl -n kube-system describe secret default | grep '^token' | sed 's/token\:\ *//')
kubectl config set-credentials docker-desktop --token="$TOKEN"

# Forward the dashboard to
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
#
# When logging in, select "Kubeconfig" and navigate to
# ~/.kube/config (Cmd+Shift+. shows hidden files in Safari,
# Cmd+Shift+G lets you enter a folder name)
kubectl proxy
