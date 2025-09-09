#!/bin/bash
# Usage: source ./setenv.sh .env

ENV_FILE="${1:-.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Env file '$ENV_FILE' not found."
  exit 1
fi

for ENTRY in $(cat "$ENV_FILE"); do
  export ${ENTRY}
done
