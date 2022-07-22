#!/usr/bin/env bash
set -euo pipefail
# Allows 
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- scriptit.sh "$@"
fi
exec "$@"
