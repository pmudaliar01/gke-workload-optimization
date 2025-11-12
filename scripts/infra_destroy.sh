#!/usr/bin/env bash
set -euo pipefail
: "${GOOGLE_PROJECT_ID:?need GOOGLE_PROJECT_ID}"
: "${GOOGLE_REGION:=us-central1}"
: "${GOOGLE_ZONE:=us-central1-a}"

pushd terraform >/dev/null
  # Reinitialize so TF locks/reads state from GCS backend
  terraform init -input=false -reconfigure

  terraform destroy -auto-approve \
    -var "project_id=${GOOGLE_PROJECT_ID}" \
    -var "region=${GOOGLE_REGION}" \
    -var "zone=${GOOGLE_ZONE}"
popd >/dev/null
