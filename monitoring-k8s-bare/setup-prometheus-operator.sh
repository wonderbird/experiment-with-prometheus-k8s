#!/bin/bash

helm install --name prom-operator -f prometheus-operator-values.yaml stable/prometheus-operator
