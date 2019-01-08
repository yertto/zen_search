#!/bin/bash

if ! type jq > /dev/null 2>&1; then
  echo "Missing dependency: jq"
  echo "Try 'brew install jq' or visit https://stedolan.github.io/jq/download/"
  exit 1
fi

DATA_DIR=${DATA_DIR:-./data}
JQ_DIR=${JQ_DIR:-./jq}

resources() {
  find "$DATA_DIR" -type f -exec basename {} .json \; | sort -r
}
RESOURCES=(${RESOURCES:-$(resources)})

keys_for() { local resource="$1"
  jq --raw-output \
     -f "$(jq_file keys)" \
     "$(json_file "${resource}")"
}

values_for() { local resource="$1"; local key="$2"
  jq --raw-output \
     --arg key "$key" \
     -f "$(jq_file values)" \
     "$(json_file "${resource}")"
}

find_() { local resource="$1"; local _id="$2"
  (
    IFS=' '
    jq --color-output \
       --argjson value "$(quote "$_id")" \
       $(slurpfiles_for "$resource") \
       -f "$(jq_file "${resource}")" \
       -L "${JQ_DIR}" \
       "$(json_file "${resource}")"
  )
}

find_by() { local resource="$1"; local key="$2"; local value="$3"
  (
    IFS=' '
    jq --raw-output \
       --arg key "$key" \
       --argjson value "$(quote "$value")" \
       -f "$(jq_file find_by)" \
       $(slurpfiles_for "$resource") \
       -L "${JQ_DIR}" \
      "$(json_file "${resource}")"
  )
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
  # TODO: remove the requirement for IFS=' ' whenever this is called.  :(
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
