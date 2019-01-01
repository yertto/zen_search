#!/bin/bash
DATA_DIR=${DATA_DIR:-./data}
JQ_DIR=${JQ_DIR:-./jq}

resources() {
  find "$DATA_DIR" -type f -exec basename {} .json \; | sort -r
}
RESOURCES=(${RESOURCES:-$(resources)})

keys_for() { local resource="$1"
  jq --raw-output 'first | keys_unsorted | join(" ")' "$(json_file "${resource}")"
}

values_for() { local resource="$1"; local key="$2"
  jq --raw-output "[.[] | ([.${key}] | flatten)[]] | unique[] | @text" "$(json_file "${resource}")"
}

show() { local resource="$1"; local _id="$2"
  jq --color-output --argjson value "$(quote "$_id")" $(slurpfiles_for "$resource") -f "$(jq_file "${resource}")" "$(json_file "${resource}")"
}

index() { local resource="$1"; local key="$2"; local value="$3"
  jq ".[] | select([.${key}] | flatten | index($(quote "$value"))) | ._id" \
    "$(json_file "${resource}")"
}

jq_file() { local resource="$1"
  echo "${JQ_DIR}/${resource}.jq"
}

json_file() { local resource="$1"
  echo "${DATA_DIR}/${resource}.json"
}

quote() { local value="$1"
  if [[ $value =~ ^([[:digit:]]+|true|false)$ ]]; then
    echo "$value"
  elif [[ -z $value ]] || [[ $value == null ]]; then
    echo "null"
  else
    echo "\"$value\""
  fi
}

slurpfiles_for() { local resource="$resource"
  case "$resource" in
    users)
      echo "--slurpfile tickets_array $(json_file tickets) --slurpfile organizations_array $(json_file organizations)" ;;
    tickets)
      echo "--slurpfile   users_array $(json_file   users) --slurpfile organizations_array $(json_file organizations)" ;;
    organizations)
      echo "--slurpfile tickets_array $(json_file tickets) --slurpfile         users_array $(json_file         users)" ;;
    *) ;;
  esac
}
