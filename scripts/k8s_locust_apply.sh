#!/usr/bin/env bash
set -euo pipefail
kubectl -n lab apply -f k8s/locust/00-configmap-tasks.yaml
kubectl -n lab apply -f k8s/locust/10-locust-main.yaml
kubectl -n lab apply -f k8s/locust/20-locust-workers.yaml
kubectl -n lab get svc locust-main
