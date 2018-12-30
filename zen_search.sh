#!/bin/bash

keys_for() { local repository="$1"
  jq --raw-output 'first | keys_unsorted | join(" ")' "$1.json"
}
