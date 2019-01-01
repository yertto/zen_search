#!/bin/bash
# Dependency on `dialog`
#   https://invisible-island.net/dialog/dialog.html

menu_options() { local items=($@)
  height=$((${#items[@]}))
  options="$(stty size) $height "
  for i in "${!items[@]}"; do
    options="${options} $i \"${items[$i]}\" "
  done
  echo "$options"
}

menu() { local title="$1"; shift; local items=($@)
  eval dialog --menu "$title" "$(menu_options "${items[@]}")" 2>&1 > /dev/tty
}

