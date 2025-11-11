#!/usr/bin/env bash
set -euo pipefail
: "${GOOGLE_PROJECT_ID:?need GOOGLE_PROJECT_ID}"
: "${GOOGLE_REGION:=us-central1}"
: "${GOOGLE_ZONE:=us-central1-a}"

pushd terraform >/dev/null
  terraform init -input=false
  terraform apply -auto-approve     -var "project_id=${GOOGLE_PROJECT_ID}"     -var "region=${GOOGLE_REGION}"     -var "zone=${GOOGLE_ZONE}"
popd >/dev/null

gcloud container clusters get-credentials "test-cluster" --zone "${GOOGLE_ZONE}" --project "${GOOGLE_PROJECT_ID}"
kubectl get nodes
