#!/bin/bash
DATA_DIR=${DATA_DIR:-./data}

keys_for() { local repository="$1"
  jq --raw-output 'first | keys_unsorted | join(" ")' "${DATA_DIR}/$1.json"
}
