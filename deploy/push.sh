#!/usr/bin/env bash
# Setup script
setup() {
  :
  # Unofficial bash strictmode - http://redsymbol.net/articles/unofficial-bash-strict-mode/
  set -euo pipefail
  IFS=$'\n\t'

  # Directory of the executed script
  SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

  # Delightful git commands
  GIT_REPO=$(git rev-parse --show-toplevel)
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  GIT_HASH=$(git rev-parse HEAD)
  GIT_DESCRIBE=$(git describe --dirty --tags --long)
  GIT_SHORT_HASH=$(git rev-parse --short HEAD)
}

run() {
  echo "$0"
  docker push onescriptkid/scriptit:latest
  docker push onescriptkid/scriptit:"$GIT_SHORT_HASH"
  docker push onescriptkid/scriptit:"$GIT_DESCRIBE"
}

setup
run