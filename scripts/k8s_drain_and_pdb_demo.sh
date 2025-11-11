#!/usr/bin/env bash
set -euo pipefail
echo "[Before PDB] Draining nodes (may reduce available pods)..."
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --force --ignore-daemonsets --grace-period=10 "$node" || true
done
kubectl -n lab describe deploy gb-frontend | grep '^Replicas' || true

echo "Uncordon nodes..."
for node in $(kubectl get nodes -o=name); do
  kubectl uncordon "$node" || true
done

echo "Ensure PDB is applied, then drain again:"
kubectl -n lab apply -f k8s/50-pdb.yaml
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --timeout=30s --ignore-daemonsets --grace-period=10 "$node" || true
done
kubectl -n lab describe deploy gb-frontend | grep '^Replicas' || true

echo "Stop draining, uncordon all:"
for node in $(kubectl get nodes -o=name); do
  kubectl uncordon "$node" || true
done
