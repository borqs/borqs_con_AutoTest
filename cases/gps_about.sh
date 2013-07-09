#!/bin/bash
source $(pwd)/cases/dut_operations.sh


###################################################################################
###### Check
###################################################################################
function enable_gps_location_providers() {
#back home
  local select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name = 'location_providers_allowed';"`

#"select maybe "network,gps\r" or "network\r" or "gps\r" or "\r"
  if [ "${#select}" = "12" ] || [ "${#select}" = "4" ]; then
    echo "${FUNCNAME} [OK]" && return
  fi

  cursor_back_home 
  adb shell am start -a android.settings.LOCATION_SOURCE_SETTINGS > /dev/null
  reset_cursor_to_top
  cursor_down
  cursor_click
  sleep 3s
  select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name =     'location_providers_allowed';"`

  if [ "${#select}" = "12" ] || [ "${#select}" = "4" ]; then
    echo "${FUNCNAME} success" && return
  fi
  echo "${FUNCNAME} fail"
}
 
function disable_gps_location_providers() {
#back home
  local select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name = 'location_providers_allowed';"`

#"select maybe "network,gps\r" or "network\r" or "gps\r" or "\r"
  if [ "${#select}" = "1" ] || [ "${#select}" = "8" ]; then
    echo "${FUNCNAME} [OK]" && return
  fi

  cursor_back_home 
  adb shell am start -a android.settings.LOCATION_SOURCE_SETTINGS > /dev/null
  reset_cursor_to_top
  cursor_down
  cursor_click
  sleep 3s
  select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name =     'location_providers_allowed';"`

  if [ "${#select}" = "1" ] || [ "${#select}" = "8" ]; then
    echo "${FUNCNAME} success" && return
  fi
  echo "${FUNCNAME} fail"
}

function enable_network_location_providers() {
#back home
  local select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name = 'location_providers_allowed';"`

#"select maybe "network,gps\r" or "network\r" or "gps\r" or "\r"
  if [ "${#select}" = "12" ] || [ "${#select}" = "8" ]; then
    echo "${FUNCNAME} [OK]" && return
  fi

  cursor_back_home 
  adb shell am start -a android.settings.LOCATION_SOURCE_SETTINGS > /dev/null
  reset_cursor_to_top
  cursor_click
  cursor_right
  cursor_click
  sleep 3s
  select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name =     'location_providers_allowed';"`

  if [ "${#select}" = "12" ] || [ "${#select}" = "8" ]; then
    echo "${FUNCNAME} success" && return
  fi
  echo "${FUNCNAME} fail"
}

function disable_network_location_providers() {
#back home
  local select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name = 'location_providers_allowed';"`

#"select maybe "network,gps\r" or "network\r" or "gps\r" or "\r"
  if [ "${#select}" = "1" ] || [ "${#select}" = "4" ]; then
    echo "${FUNCNAME} [OK]" && return
  fi

  cursor_back_home 
  adb shell am start -a android.settings.LOCATION_SOURCE_SETTINGS > /dev/null
  reset_cursor_to_top
  cursor_click
  sleep 3s
  select=`adb shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select value from secure where name =     'location_providers_allowed';"`

  if [ "${#select}" = "1" ] || [ "${#select}" = "4" ]; then
    echo "${FUNCNAME} success" && return
  fi
  echo "${FUNCNAME} fail"
}

