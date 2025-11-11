#!/usr/bin/env bash
set -euo pipefail
kubectl -n lab apply -f k8s/60-liveness-demo.yaml
kubectl -n lab apply -f k8s/70-readiness-demo.yaml
kubectl -n lab get svc readiness-demo-svc
