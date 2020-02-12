#!/bin/bash
helm install --name blackbox-exporter -f blackbox-exporter-values.yaml stable/prometheus-blackbox-exporter
