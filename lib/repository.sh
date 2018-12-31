#!/bin/bash
DATA_DIR=${DATA_DIR:-./data}

keys_for() { local resource="$1"
  jq --raw-output 'first | keys_unsorted | join(" ")' "$(json_file "${resource}")"
}

show() { local resource="$1"; local _id="$2"
  jq ".[] | select(._id==$(quote "$_id"))" "$(json_file "${resource}")"
}

index() { local resource="$1"; local key="$2"; local value="$3"
  jq ".[] | select(.${key}==$(quote "$value")) | ._id" "$(json_file "${resource}")"
}

json_file() { local resource="$1"
  echo "${DATA_DIR}/${resource}.json"
}

quote() { local value="$1"
  if [[ $value =~ ^[[:digit:]]+$ ]]; then
    echo "$value"
  else
    echo "\"$value\""
  fi
}
