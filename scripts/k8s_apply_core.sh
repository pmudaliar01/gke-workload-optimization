#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f k8s/00-namespace.yaml
kubectl -n lab apply -f k8s/10-gb-frontend-pod.yaml
kubectl -n lab apply -f k8s/20-svc-neg.yaml
kubectl -n lab apply -f k8s/30-ingress.yaml
kubectl -n lab get ingress gb-frontend-ingress
