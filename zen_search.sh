#!/bin/bash

jq --raw-output 'first | keys_unsorted | join(" ")' "$1.json"
