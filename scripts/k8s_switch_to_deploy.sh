#!/usr/bin/env bash
set -euo pipefail
kubectl -n lab delete pod gb-frontend --ignore-not-found
kubectl -n lab apply -f k8s/40-gb-frontend-deploy.yaml
kubectl -n lab rollout status deploy/gb-frontend
kubectl -n lab apply -f k8s/50-pdb.yaml
