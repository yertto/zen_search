#!/bin/bash
DATA_DIR=${DATA_DIR:-./data}

keys_for() { local repository="$1"
  jq --raw-output 'first | keys_unsorted | join(" ")' "$(json_file "${repository}")"
}

show() { local repository="$1"; local _id="$2"
  jq ".[] | select(._id==$(quote "$_id"))" "$(json_file "${repository}")"
}

json_file() { local repository="$1"
  echo "${DATA_DIR}/${repository}.json"
}

quote() { local value="${value}"
  if [[ $value =~ ^[[:digit:]]+$ ]]; then
    echo "$value"
  else
    echo "\"$value\""
  fi
}
