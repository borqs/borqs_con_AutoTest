#!/bin/bash

function OPS_TAG() {
  echo "" >> ${OK_FAIL}
  echo "$1 ..." >> ${OK_FAIL}
}

function OPS_CHECK() {
  echo "$1 [CHECK]" >> ${OK_FAIL}
  sleep 1s
}

function OPS_MANUAL() {
  echo "$1 [MANUAL]" >> ${OK_FAIL}
  sleep 1s
}

function OPS_FAIL() {
  echo "$1 [FAIL]" >> ${OK_FAIL}
  sleep 1s
}

function OPS_OK() {
  echo "$1 [OK]" >> ${OK_FAIL}
  sleep 1s
}

function OPS_RET() {
  echo "$1" >> ${OK_FAIL}
  echo "ret :$2" >> ${OK_FAIL}
  sleep 1s
}
function cursor_up_rel() {
  local n=$1
  for((i=0; i<$n; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 19
  done
  sleep 1s
}

function cursor_down_rel() {
  local n=$1
  for((i=0; i<$n; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 20
  done
  sleep 1s
}

function reset_cursor_to_top() {
  for((i=0; i<10; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 19
  done
  sleep 1s
}

function reset_cursor_to_bottom() {
  for((i=0; i<10; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 20
  done
  sleep 1s
}

function cursor_go() {
  local n=$1
  reset_cursor_to_top
  for((i=0; i<$n; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 20
  done
}

function reset_cursor_to_top_20() {
  for((i=0; i<20; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 19
  done
  sleep 1s
}

function reset_cursor_to_bottom_20() {
  for((i=0; i<20; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 20
  done
  sleep 1s
}

function cursor_back_home() {
  adb -s ${DEVICES_MASTER} shell input keyevent 4
  adb -s ${DEVICES_MASTER} shell input keyevent 4
  adb -s ${DEVICES_MASTER} shell input keyevent 4
  sleep 1s
  adb -s ${DEVICES_MASTER} shell input keyevent 3
}

function cursor_back() {
  adb -s ${DEVICES_MASTER} shell input keyevent 4
}

function cursor_down() {
  adb -s ${DEVICES_MASTER} shell input keyevent 20
}

function cursor_up() {
  adb -s ${DEVICES_MASTER} shell input keyevent 19
}

function cursor_click() {
  adb -s ${DEVICES_MASTER} shell input keyevent 23
}

function cursor_right() {
  adb -s ${DEVICES_MASTER} shell input keyevent 22
}

function cursor_left() {
  adb -s ${DEVICES_MASTER} shell input keyevent 21
}

function cursor_menu() {
  adb -s ${DEVICES_MASTER} shell input keyevent 82
}

function input_text() {
  adb -s ${DEVICES_MASTER} shell input text "$1"
}

##eap_method: TLS/TTLS/PEAP
##phase2: PAP/MSCHAP/MSCHAPV2/GTC
function pick_method_phase2() {
  local method_num=$1
  local phase2_num=$2

  cursor_click

  #pick method
  for((i=0; i<${method_num}-1; i++)); do
    cursor_down
  done
  cursor_click

  cursor_down
  cursor_click

  #pick phase2
  for((i=0; i<${phase2_num}; i++)); do
    cursor_down
  done
  cursor_click
}

[ "${PUT_TYPE}" = "phone" ] &&
function open_wifi() {
#from home start settings
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_SETTINGS > /dev/null
  sleep 1s

#when be open, return directly
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    echo "${FUNCNAME} success"
    return
  fi

#open wifi
  cursor_go 0
  for i in 1 2 3; do
    cursor_click
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] && echo "${FUNCNAME} success" && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
} ||
function open_wifi() {
#from home start settings
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null
  sleep 1s

#when be open, return directly
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    cursor_right && echo "${FUNCNAME} success" && return
  fi

#open wifi
  for i in 1 2 3 ; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] &&
    echo "${FUNCNAME} success"&& cursor_click && cursor_right && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
}


##Open WiFi from WIRELESS & NETWORKS interface
function open_wifi_directly() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null

#when be open, return directly
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    echo "${FUNCNAME} success"
    return
  fi

#open wifi
  for i in 1 2 3 ; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] &&
    echo "${FUNCNAME} success"&& cursor_click && cursor_right && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
}

[ "${PUT_TYPE}" = "phone" ] &&
function close_wifi() {
#from home to wifi settting
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_SETTINGS > /dev/null
  sleep 1s

  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]; then
    echo "${FUNCNAME} success"
    return
  fi

## When be open, close it
  reset_cursor_to_top
  for i in 1 2 3 4 5 6; do
    cursor_click
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ] && echo "${FUNCNAME} success" && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
} ||
function close_wifi() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null
  sleep 1s

  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]; then
    echo "${FUNCNAME} success"
    return
  fi

  for i in 1 2 3 4 5 6; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ] &&
    echo "${FUNCNAME} success" && cursor_click && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
}

##Close WiFi from WIRELESS & NETWORKS interface
function close_wifi_directly() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null

  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]; then
    echo "${FUNCNAME} success"
    return
  fi

  for i in 1 2 3 4 5 6; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 3s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ] &&
    echo "${FUNCNAME} success" && cursor_click && sleep 5s && return
  done

  echo "${FUNCNAME} fail"
}

function reopen_wifi() {
#from home start settings
  for i in 1 2 3; do
    if [ "$(close_wifi)" = "close_wifi success" ] && [ "$(open_wifi)" = "open_wifi success" ]; then
      echo "${FUNCNAME} success" && return
    fi
    sleep 5s
  done
  echo "${FUNCNAME} fail"
}

##basic operations: add network, connect first ssid in list, manual scan
##                  forget connected ssid.
function add_network() {
  local arg=$1
  local ssid=${SSID}
  local mode=${SECURT_MODE_WPA_WPA2}
  local show_mode=false
  local show_mode_png="${FUNCNAME}_mode.png"
  local password=${SSID_PASSWORD}
  local method=${PEAP}
  local phase2=${NONE}
  local identity=${IDENTITY}
  local eap_user_password=${EAP_USER_PASSWORD}
  local show_password=false
  local show_password_png="${FUNCNAME}_password.png"
  local show_advances=false
  local enable_advances=false
  local show_advances_png="${FUNCNAME}_advances.png"
  local ip_address=${PUT_IP_ADDR}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "ssid")
      ssid=${value}
      ;;
    "mode")
      mode=${value}
      ;;
    "show_mode")
      show_mode=${value}
      ;;
    "show_mode_png")
      show_mode_png=${value}
      ;;
    "password")
      password=${value}
      ;;
    "method")
      method=${value}
      ;;
    "phase2")
      phase2=${value}
      ;;
    "eap_user_password")
      eap_user_password=${value}
      ;;
    "show_password")
      show_password=${value}
      ;;
    "show_password_png")
      show_password_png=${value}
      ;;
    "show_advances")
      show_advances=${value}
      ;;
    "enable_advances")
      enable_advances=${value}
      ;;
    "show_advances_png")
      show_advances_png=${value}
      ;;
    "put_ip_address")
      put_ip_address=${value}
      ;;
    esac
  done
  sleep 1s

#open add network
  if [ "$(open_wifi)" = "open_wifi fail" ] ; then
    echo "${FUNCNAME} fail"
    return
  fi
#add network
  adb -s ${DEVICES_MASTER} shell input touchscreen tap ${ADD_NETWORK_X_Y}
  sleep 1s
#input ssid
  cursor_go 0
  input_text ${ssid}
  cursor_down
  sleep 1s
#mode
  cursor_click
  cursor_go 0
  sleep 1s

  if [ "${mode}" = "${SECURT_MODE_DISABLE}" ]; then
  #select none
    cursor_down_rel 0
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
  elif [ "${mode}" = "${SECURT_MODE_WEP}" ]; then
    cursor_down_rel 1
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_down
    if [ "${PUT_TYPE}" = "phone" ]; then {
      input_text ${password}
    } else {
      # It is a BUG for CLT 7.85
      cursor_up
      input_text ${password}
   }
   fi
  elif [ "${mode}" = "${SECURT_MODE_WPA_WPA2}" ]; then
    cursor_down_rel 2
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_down
    if [ "${PUT_TYPE}" = "phone" ]; then {
      input_text ${password}
    } else {
      # It is a BUG for CLT 7.85
      cursor_up
      input_text ${password}
   }
   fi
  elif [ ${mode/"enterprise"//} != $mode ]; then
    cursor_down_rel 3
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_down

    #pick eap method and phase2
    pick_method_phase2 ${method} ${phase2}

    cursor_down
    #CA certificate
    cursor_click
    cursor_down
    cursor_click

    cursor_down
    #User certificate
    cursor_click
    cursor_down
    cursor_click

    cursor_down
    #identity
    input_text ${identity}
    cursor_down
    cursor_down
    input_text ${eap_user_password}
  fi
    sleep 1s

#show password and do screen captrue
  if [ "${mode}" != "${SECURT_MODE_DISABLE}" ]; then
    cursor_down
    if [ "${show_password}" = "true" ]; then
      cursor_click
      [ "$(adb_screencap png=${show_password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
  fi
#Steps for advaces
  cursor_down
  if [ "${enable_advances}" = "true" ]; then
  #show advaces
    cursor_click
  #Static IP
    cursor_down
    cursor_down
    if [ "${show_advances}" = "true" ]; then
      [ "$(adb_screencap png=${show_advances_png})" = "adb_screencap fail" ] && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_go 1
    cursor_down
    cursor_click
    cursor_down
    sleep 1s
  #IP ADDR
    input_text ${ip_address}
    sleep 1s
  ##Gateway
    cursor_down
    sleep 1s
  #Network length
    cursor_down
    sleep 1s
  #DNS1
    cursor_down
    sleep 1s
  #DNS2
    cursor_down
    adb -s ${DEVICES_MASTER} shell input text "8.8.4.4"
  fi

  reset_cursor_to_bottom
  cursor_right
  cursor_click
  sleep 15s

#It is not safe
  echo "${FUNCNAME} success"
}

#add_network show_mode=true,show_mode_png=1.png,show_password=true,show_password=true,show_password_png=2.png,enable_advances=true
#add_network mode=${SECURT_MODE_WEP},password="1234567890",show_mode=true,show_mode_png=1.png,show_password=true,show_password=true,show_password_png=2.png,enable_advances=true
#add_network mode=${SECURT_MODE_DISABLE},show_mode=true,show_mode_png=2.png,enable_advances=true
function scan_manual() {
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    echo "${FUNCNAME} fail" && return
  fi
#open && scan
  cursor_menu
  cursor_up
  cursor_click
  sleep 3s

  echo "${FUNCNAME} success"
}

function wps_pin_tap() {
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    echo "${FUNCNAME} fail" && return
  fi

#open && scan
  adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WPS_PIN_X_Y}
  sleep 3s
  echo "${FUNCNAME} success"
}

function wps_pin_entry() {
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    echo "${FUNCNAME} fail" && return
  fi

  cursor_menu
  cursor_go 1
  cursor_click

  echo "${FUNCNAME} success"
}

function wps_ops() {
  local arg=$1
  local wps_pbc=false
  local wps_pin=false
  local wps_pbc_cancel=false
  local wps_pin_cancel=false

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "wps_pbc")
      wps_pbc=${value}
      ;;
    "wps_pin")
      wps_pin=${value}
      ;;
    "wps_pbc_cancel")
      wps_pbc_cancel=${value}
      ;;
    "wps_pin_cancel")
      wps_pin_cancel=${value}
      ;;
    esac
  done

  if [ "${wps_pbc}" = "true" ]; then
    [ "$(wps_pin_tap)" = "fail" ] && echo "${FUNCNAME} fail" && return
  fi

  if [ "${wps_pin}" = "true" ]; then
    [ "$(wps_pin_entry)" = "fail" ] && echo "${FUNCNAME} fail" && return
  fi

  if [ "${wps_pbc_cancel}" = "true" ]; then
    cursor_down
    cursor_click
  fi

  if [ "${wps_pin_cancel}" = "true" ]; then
    cursor_down
    cursor_click
  fi

  echo "${FUNCNAME} success"
}

function connect_first_ssid() {
  local arg=$1
  local mode=${SECURT_MODE_WPA_WPA2}
  local password=${SSID_PASSWORD}
  local method=${PEAP}
  local phase2=${NONE}
  local identity=${IDENTITY}
  local eap_user_password=${EAP_USER_PASSWORD}
  local show_password="false"
  local show_password_png="${FUNCNAME}_password.png"
  local show_advances="false"
  local show_advances_png="${FUNCNAME}_advances.png"
  local enable_advances="false"
  local ip_address="${PUT_IP_ADDR}"

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 11; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "mode")
      mode=${value}
      ;;
    "password")
      password=${value}
      ;;
    "method")
      method=${value}
      ;;
    "phase2")
      phase2=${value}
      ;;
    "eap_user_password")
      eap_user_password=${value}
      ;;
    "show_password")
      show_password=${value}
      ;;
    "show_password_png")
      show_password_png=${value}
      ;;
    "show_advances")
      show_advances=${value}
      ;;
    "enable_advances")
      enable_advances=${value}
      ;;
    "show_advances_png")
      show_advances_png=${value}
      ;;
    "ip_address")
      ip_address=${value}
      ;;
    esac
  done

#If had been connected, just forget it !
  if [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ]; then
    [ "$(forget_first_ssid)" = "forget_first_ssid fail" ] && echo "${FUNCNAME} fail" && return
  fi

#open wifi
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    echo "${FUNCNAME} fail" && return
  fi

#click first SSID
  cursor_go 1
  sleep 1s
  if [ "${mode}" = "${SECURT_MODE_DISABLE}" ]; then
  #select none
    cursor_click
  elif [ "${mode}" = "${SECURT_MODE_WEP}" ]; then
    cursor_click
    input_text ${password}
  elif [ "${mode}" = "${SECURT_MODE_WPA_WPA2}" ]; then
    cursor_click
    input_text ${password}
  elif [ ${mode/"enterprise"//} != $mode ]; then
    cursor_click

    cursor_go 0
    #pick eap method and phase2
    pick_method_phase2 ${method} ${phase2}

    cursor_down
    #CA certificate
    cursor_click
    cursor_down
    cursor_click

    cursor_down
    #User certificate
    cursor_click
    cursor_down
    cursor_click

    cursor_down
    #identity
    input_text ${identity}
    cursor_down
    cursor_down
    input_text ${eap_user_password}
  fi
  sleep 1s

#show password and do screen captrue
  if [ "${mode}" != "${SECURT_MODE_DISABLE}" ]; then
    cursor_down
    if [ "${show_password}" = "true" ]; then
      cursor_click
      [ "$(adb_screencap png=${show_password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_down
  fi
#Steps for advaces
  if [ "${enable_advances}" = "true" ]; then
  #show advaces
    cursor_click
  #Static IP
    cursor_down
    cursor_down
    if [ "${show_advances}" = "true" ]; then
      [ "$(adb_screencap png=${show_advances_png})" = "adb_screencap fail" ] && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_go 1
    cursor_down
    cursor_click
    cursor_down
    sleep 1s
  #IP ADDR
    input_text ${ip_address}
    sleep 1s
  ##Gateway
    cursor_down
    sleep 1s
  #Network length
    cursor_down
    sleep 1s
  #DNS1
    cursor_down
    sleep 1s
  #DNS2
    cursor_down
    adb -s ${DEVICES_MASTER} shell input text "8.8.4.4"
  fi

  if [ "${mode}" != "${SECURT_MODE_DISABLE}" ]; then
    reset_cursor_to_bottom
    cursor_right
    cursor_click
  fi

  sleep 15s

#check results
  if [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ]; then
    echo "${FUNCNAME} success"
  else
    echo "${FUNCNAME} fail"
  fi
}

#connect_first_ssid mode=${SECURT_MODE_WEP},password="1234567890",show_password=true,show_password_png=1.png,enable_advances=true,show_advances=true,show_advances_png=2.png
#connect_first_ssid mode=${SECURT_MODE_DISABLE}

function forget_first_ssid() {
  [ "$(adb_rm src=${PUT_WPA_SUPPLICANT_CONF})" = "adb_rm fail" ] && echo "${FUNCNAME} fail" && return
  sleep 3s
  for i in 1 2 3; do
    if [ "$(reopen_wifi)" = "reopen_wifi success" ]; then
      sleep 5s
      [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] && echo "${FUNCNAME} success" && return
    fi
    sleep 5s
  done
  echo "${FUNCNAME} fail"
}

##clean wifi operations:
function clean_wifi_ops() {
  local tag=$1
#forget
  cursor_back_home
  [ "$(adb_rm src=${PUT_WPA_SUPPLICANT_CONF})" = "adb_rm fail" ] && echo "${FUNCNAME} fail" && return
  adb -s ${DEVICES_MASTER} shell rm -fr /data/PFT_* > /dev/null
#close
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    for i in 1 2 3 ;do
      if [ "$(close_wifi)" = "close_wifi success" ]; then
        break
      else
        sleep 5s
      fi
      [ "${i}" = "3" ] && echo "${FUNCNAME} fail" && OPS_FAIL ${tag}_${FUNCNAME} && cursor_back_home && return
    done
  fi

#back home
  cursor_back_home
  echo "${FUNCNAME} success"
}

##eg: browser_load_web
function browser_ops() {
  local arg=$1
  local http=${WEB_INDEX}
  local png=${FUNCNAME}.png
  local name=""

  [ "${arg}" != "" ] &&
  for i in 1 2 3; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "http")
      http=${value}
      ;;
    "png")
      png=${value}
      ;;
    "name")
      name=${value}
      ;;
    esac
  done

#download data
  if [ "${name}" != "" ]; then
    [ "$(adb_push src=${PC_CURL},des=${PUT_CURL})" = "adb_push fail" ] && echo "${FUNCNAME} fail" && return
    adb -s ${DEVICES_MASTER} shell curl -o ${PUT_DOWNLOAD_DIR}/${name} ${http} > /dev/null
    sleep 3s
    adb -s ${DEVICES_MASTER} pull ${PUT_DOWNLOAD_DIR}/${name} ${PC_DOWNLOAD_DIR}/${name} > /dev/null
    [ -e "${PC_DOWNLOAD_DIR}/${name}" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
    return
  fi

#open web page
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.intent.action.VIEW -d "${http}" > /dev/null
  sleep 5s

  [ "$(adb_screencap png=${png})" = "adb_screencap success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function airplane_ops() {
  local allow=$1
  [ "${allow}" != "false" ] && [ "${allow}" != "true" ] && echo "${FUNCNAME} fail" && return

  local select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  local tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  cursor_back_home

  if [ "${PUT_TYPE}" = "phone" ]; then
    adb -s ${DEVICES_MASTER} shell am start -a android.settings.AIRPLANE_MODE_SETTINGS > /dev/null
    cursor_go 1
  else
    adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null
    cursor_go 0
    cursor_left
    cursor_down
    cursor_down
    cursor_down
    cursor_click
    cursor_right
    cursor_go 0
  fi

  if [ "${allow}" = "true" ]; then
    [ "${tag}" = "1" ] && echo "${FUNCNAME} success" && return
  elif [ "${allow}" = "false" ]; then
    [ "${tag}" != "1" ] && echo "${FUNCNAME} success" && return
  fi

  cursor_click

  select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  if [ "${allow}" = "true" ]; then
    [ "${tag}" = "1" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  elif [ "${allow}" = "false" ]; then
    [ "${tag}" != "1" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  fi

#sleep
  sleep 15s
}

function master_clear() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.BACKUP_AND_RESET_SETTINGS > /dev/null
  reset_cursor_to_top
  cursor_down
  cursor_click
#Reset phone
  reset_cursor_to_bottom
  cursor_click
  reset_cursor_to_bottom
  cursor_click
  for i in 1 2 3 4 5 6 7 8 9 10; do
    local error=`adb get-state`
    [ "${error}" != "device" ] && echo "${FUNCNAME} success" && sleep 150s && return
    sleep 3s
  done
  echo "${FUNCNAME} fail"
}

function wifi_advances_ops() {
  local arg=$1
  local show_ip_mac=false
  local enable_freq_band=false
  local set_freq_band="auto"
  local show_freq_band="auto"
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "show_ip_mac")
      show_ip_mac=${value}
      ;;
    "enable_freq_band")
      enable_freq_band=${value}
      ;;
    "set_freq_band")
      set_freq_band=${value}
      ;;
    "show_freq_band")
      show_freq_band=${value}
      ;;
    "png")
      png=${value}
      ;;
    esac
  done

  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_IP_SETTINGS > /dev/null
  sleep 3s

  if [ "${show_ip_mac}" = "true" ]; then
    cursor_go 7
  elif [ "${enable_freq_band}" = "true" ]; then
    cursor_go 4
    cursor_click
    [ "${set_freq_band}" = "24g" ] && cursor_go 2 && cursor_click && sleep 1s
    [ "${set_freq_band}" = "5g" ] && cursor_go 1 && cursor_click && sleep 1s
    [ "${set_freq_band}" = "auto" ] && cursor_go 0 && cursor_click && sleep 1s
    [ "${show_freq_band}" = "true" ] && cursor_click && sleep 1s
  fi

  if [ "$(adb_screencap png=${png})" = "adb_screencap success" ] ;then
    echo "${FUNCNAME} success"
  else
    echo "${FUNCNAME} fail"
  fi

#Be sure that there is not any dialog show before quit
  cursor_back_home
}

function screen_captrue_ssid_ops() {
  local arg=$1
  local png="${FUNCNAME}.png"
  local locate="head"

  [ "${arg}" != "" ] &&
  for i in 1 2; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
      ;;
    "locate")
      locate=${value}
      ;;
    esac
  done

  [ "$(open_wifi)" = "open_wifi fail" ] && echo "${FUNCNAME} fail" && return
  sleep 3s

  if [ "${locate}" = "first" ]; then
    cursor_go 1
    cursor_click
  elif [ "${locate}" = "head" ]; then
    cursor_go 0
  elif [ "${locate}" = "tail" ]; then
    reset_cursor_to_bottom_20
  elif [ "${locate}" = "last" ]; then
##When ap in list more than one screen, It a BUG !!!
    reset_cursor_to_bottom_20
    [ "${PUT_TYPE}" = "phone" ] && cursor_up
    cursor_click
  fi
  sleep 3s

  [ "$(adb_screencap png=${png})" = "adb_screencap success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"

# Maybe you have reset_cursor_to_bottom_20, reset_cursor_to_top would accurate that your cursor stay head
  if [ "${locate}" = "last" ]; then
    cursor_back
    reset_cursor_to_top_20
  elif [ "${locate}" = "tail" ]; then
    reset_cursor_to_top_20
  fi
  cursor_back_home
}

function adb_push() {
  local arg=$1
  local src=""
  local des=""

  [ "${arg}" != "" ] &&
  for i in 1 2; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "src")
      src=${value}
      ;;
    "des")
      des=${value}
      ;;
    esac
  done

  if [ "${src}" = "" ] || [ "${des}" = "" ]; then
    echo "${FUNCNAME} fail" && return
  fi

  [ -e ${src} ] ||
  {
    echo "${FUNCNAME} fail" && return
  }

#Just come to do job
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} remount > /dev/null
  adb -s ${DEVICES_MASTER} push ${src} ${des} > /dev/null
  sleep 1s

  check=`adb -s ${DEVICES_MASTER} shell ls ${des} | grep "No such file"`
  [ "${check}" = "" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function adb_rm() {
  local src=`echo $1 | grep "src=" | awk -F "=" '{ print $2 }'`

  [ "${src}" = "" ] && echo "${FUNCNAME} fail" && return

#If src file does not exist, just return
  local est=`adb -s ${DEVICES_MASTER} shell ls ${src} | grep "No such file"`
  [ "${est}" != "" ] && echo "${FUNCNAME} success" && return

#That may really do what you want to
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} shell rm ${src} > /dev/null
  local re_est=`adb -s ${DEVICES_MASTER} shell ls ${src} | grep "No such file"`
  [ "${re_est}" != "" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function pc_iperf_c() {
  iperf -c ${PUT_IP_ADDR} -t 30 > /dev/null
  [ "$?" = "0" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function pc_iperf_s() {
  iperf -sD > /dev/null
  [ "$?" = "0" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function dut_iperf_c() {
  local tag=$1
  local arr_rate_Mbit=(`adb -s ${DEVICES_MASTER} shell iperf -c ${PC_IP_ADDR} -i 10 -t 30 -M | grep "Mbits/sec" | awk  -F "MBytes | Mbits/sec" '{ print $2 }'`)
  [ "${arr_rate_Mbit[*]}" = "" ] && echo "${FUNCNAME} fail" && return
  local len=${#arr_rate_Mbit[*]}
  local sum=0
  local avg=0

  for var in ${arr_rate_Mbit[*]}; do
    [ "${var}" = "" ] && var=0
    sum=`echo "scale=4;${sum} + ${var}" | bc`
  done

  avg=`echo "scale=4;${sum} / ${len}" | bc`
  echo "${tag}: ${avg} Mbit/s" >> ${DATA_THROUGHPUT}
  sleep 1s
  echo "${FUNCNAME} success"
}

function dut_iperf_s() {
  local tag=$1
  local arr_rate_Mbit=(`adb -s ${DEVICES_MASTER} shell iperf -s -i 10 -M | grep "Mbits/sec" | awk  -F "MBytes | Mbits/sec" '{ print $2 }'`)
  [ "${arr_rate_Mbit[*]}" = "" ] && echo "${FUNCNAME} fail" && return
  local len=${#arr_rate_Mbit[*]}
  local sum=0
  local avg=0

  for var in ${arr_rate_Mbit[*]}; do
    [ "${var}" = "" ] && var=0
    sum=`echo "scale=4;${sum} + ${var}" | bc`
  done

  avg=`echo "scale=4;${sum} / ${len}" | bc`
  echo "${tag}: ${avg} Mbit/s" >> ${DATA_THROUGHPUT}
  sleep 1s
  echo "${FUNCNAME} success"
}

function pc_kill_9_iperf_s() {
  local pids=`ps -aux | grep "iperf -s" | grep [0-9] | awk '{ print $2 }'`
  for pid in ${pids[*]}; do
    kill -9 ${pid} > /dev/null
  done
}

function dut_kill_9_iperf_s() {
  local pids=(`adb -s ${DEVICES_MASTER} shell ps | grep "iperf" | awk '{ print $2 }'`)
  for pid in ${pids[*]}; do
    adb -s ${DEVICES_MASTER} shell kill -9 ${pid} > /dev/null
  done
}

function DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_BG})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s &&
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c ${FUNCNAME})" = "dut_iperf_c success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_BG})" = "set_ap_ops fail" ] && return

  if [ "$(add_network enable_advances=true)" = "add_network success" ] &&
     [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
     [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
     [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s ;then
     {
       sleep 5s
       pc_iperf_c
       sleep 3s
       dut_kill_9_iperf_s
     }&
     [ "$(dut_iperf_s ${FUNCNAME})" = "dut_iperf_s success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  fi
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}

function DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_5g=${NETWORK_MODE_A})" = "set_ap_ops fail" ] && return

  [ "$(add_network ssid=${SSID_5G},enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s &&
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c ${FUNCNAME})" = "dut_iperf_c success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_5g=${NETWORK_MODE_A})" = "set_ap_ops fail" ] && return

  if [ "$(add_network ssid=${SSID_5G},enable_advances=true)" = "add_network success" ] &&
     [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
     [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
     [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s ;then
     {
       sleep 5s
       pc_iperf_c
       sleep 3s
       dut_kill_9_iperf_s
     }&
     [ "$(dut_iperf_s ${FUNCNAME})" = "dut_iperf_s success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  fi
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}

function DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_N},security_mode_24g=${SECURT_MODE_WPA2_PERSONAL})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s &&
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c ${FUNCNAME})" = "dut_iperf_c success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  local arg=$1
  local png=${FUNCNAME}.png

  [ "${arg}" != "" ] &&
  for i in 1 ; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "png")
      png=${value}
    ;;
    esac
  done

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_N},security_mode_24g=${SECURT_MODE_WPA2_PERSONAL})" = "set_ap_ops fail" ] && return

  if [ "$(add_network enable_advances=true)" = "add_network success" ] &&
     [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
     [ "$(screen_captrue_ssid_ops locate='first',png=${png})" = "screen_captrue_ssid_ops success" ] &&
     [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s ; then
     {
       sleep 5s
       pc_iperf_c
       sleep 3s
       dut_kill_9_iperf_s
     }&
     [ "$(dut_iperf_s ${FUNCNAME})" = "dut_iperf_s success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  fi
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
}
