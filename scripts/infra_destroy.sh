#!/usr/bin/env bash
set -euo pipefail
pushd terraform >/dev/null
  terraform destroy -auto-approve
popd >/dev/null
