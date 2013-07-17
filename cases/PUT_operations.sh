#!/bin/bash

function work_tag() {
  echo " " >> ${OK_FAIL} && echo "$1 ..." >> ${OK_FAIL}
}

function check() {
  echo "$1 [CHECK]" >> ${OK_FAIL}
}

function manual() {
  echo "$1 [MANUAL]" >> ${OK_FAIL}
}

function opt_fail() {
  echo "$1 [FIAL]" >> ${OK_FAIL}
}

function opt_ok() {
  echo "$1 [OK]" >> ${OK_FAIL}
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
   
#################################################################################
##basic operations: open wifi, close wifi.
#################################################################################
function open_wifi() {
#from home start settings
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_SETTINGS > /dev/null
  sleep 1s

#when be open, return directly
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then 
    echo "$FUNCNAME success"
    return
  fi

#open wifi
  cursor_go 0
  cursor_click
  sleep 3s
 
#check 
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}


##Open WiFi from WIRELESS & NETWORKS interface
function open_wifi_directly() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null
  
  for i in 1 2 3 ; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 2s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] &&
    echo "$FUNCNAME success"&& cursor_click && return
  done

  echo "$FUNCNAME fail"
}

function close_wifi() {
#from home to wifi settting
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_SETTINGS > /dev/null
  sleep 1s

## When be open, close it
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    reset_cursor_to_top
    cursor_click
  fi
  sleep 0.5s

  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

##Close WiFi from WIRELESS & NETWORKS interface
function close_wifi_directly() {
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.SETTINGS > /dev/null
  
  for i in 1 2 3 ; do
    adb -s ${DEVICES_MASTER} shell input touchscreen tap ${WIRELESS_NETWORK_WIFI_X_Y}
    sleep 2s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ] &&
    echo "$FUNCNAME success" && cursor_click && return
  done

  echo "$FUNCNAME fail"
}

function reopen_wifi() {
#from home start settings
  if [ "$(close_wifi)" = "close_wifi success" ] && [ "$(open_wifi)" = "open_wifi success" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

#####################################################################################
##basic operations: add network, connect first ssid in list, manual scan
##                  forget connected ssid.
##################################################################################### 
function add_network() {
  local arg=$1
  local ssid=${SSID}
  local mode=${SECURT_MODE_WPA_WPA2}
  local show_mode=false
  local show_mode_png="${FUNCNAME}_mode.png"
  local password=${SSID_PASSWORD}
  local show_password=false
  local show_password_png="${FUNCNAME}_password.png"
  local show_advances=false
  local enable_advances=false
  local show_advances_png="${FUNCNAME}_advances.png"
  local ip_address=${PUT_IP_ADDR}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 11; do 
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
    input_text ${password}
  elif [ "${mode}" = "${SECURT_MODE_WPA_WPA2}" ]; then
    cursor_down_rel 2
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    cursor_down
    input_text ${password}
  elif [ "${mode}" = "${SECURT_MODE_ENTERPRISE_MIXED_MODE}" ]; then
    cursor_down_rel 3
    if [ "${show_mode}" = "true" ]; then
      [ "$(adb_screencap png=${show_mode_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi
    cursor_click
    ##Do for EAP#
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
#########################################################################################
function scan_manual() {
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    [ "$(open_wifi)" = "open_wifi fail" ] && 
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    echo "$FUNCNAME fail" && return
  fi
#open && scan
  cursor_menu
  cursor_up
  cursor_click
  sleep 3s

  echo "$FUNCNAME success"
}

function enable_wps_pin() {
  if [ "$(open_wifi)" = "open_wifi fail" ]; then
    [ "$(open_wifi)" = "open_wifi fail" ] && 
    [ "$(open_wifi)" = "open_wifi fail" ] &&
    echo "$FUNCNAME fail" && return
  fi

#open && scan
  reset_cursor_to_bottom_20
  cursor_left
  cursor_click
  sleep 3s

  echo "$FUNCNAME success"
}

#########################################################################################
function connect_first_ssid() {
  local arg=$1
  local mode=${SECURT_MODE_WPA_WPA2}
  local password=${SSID_PASSWORD}
  local show_password="false"
  local password_png="${FUNCNAME}_password.png"
  local show_advances="false"
  local show_advances_png="${FUNCNAME}_advances.png"
  local enable_advances="false"
  local ip_address="${PUT_IP_ADDR}"

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8; do 
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in 
    "mode")
      mode=${value}
      ;; 
    "password")
      password=${value}
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
    echo "$FUNCNAME fail" && return
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
  elif [ "${mode}" = "${SECURT_MODE_ENTERPRISE_MIXED_MODE}" ]; then
    cursor_click
    ##Do for EAP#
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
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

#connect_first_ssid mode=${SECURT_MODE_WEP},password="1234567890",show_password=true,show_password_png=1.png,enable_advances=true,show_advances=true,show_advances_png=2.png
#connect_first_ssid mode=${SECURT_MODE_DISABLE}
###########################################################################################
##
###########################################################################################
function forget_first_ssid() {
  if [ "$(adb_push src=${PC_WPA_SUPPLICANT_CONF},des=${PUT_WPA_SUPPLICANT_CONF})" = "adb_push fail" ]; then
    echo "${FUNCNAME} fail" && return
  fi
  sleep 3s
  if [ "$(reopen_wifi)" = "reopen_wifi success" ]; then
    sleep 3s
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  else
    echo "${FUNCNAME} fail"
  fi
}

####################################################################################
##clean wifi operations:
####################################################################################
function clean_wifi_ops() {
  local tag=$1
#forget 
  cursor_back_home
  if [ "$(adb_push src=${PC_WPA_SUPPLICANT_CONF},des=${PUT_WPA_SUPPLICANT_CONF})" = "adb_push fail" ]; then
    echo "${FUNCNAME} fail" && opt_fail ${tag} && return
  fi

#close
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    echo "$FUNCNAME fail" && opt_fail ${arg} && return
  fi

#back home
  cursor_back_home
  echo "$FUNCNAME success"
}


####################################################################################
##eg: browser_load_web 
#####################################################################################
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
    [ -e "${PC_DOWNLOAD_DIR}/${name}" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
    return
  fi
    
#open web page
  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.intent.action.VIEW -d "${http}" > /dev/null
  sleep 5s

  [ "$(adb_screencap png=${png})" = "adb_screencap success" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function airplane_ops() {
  local allow=$1
  [ "${allow}" != "false" ] && [ "${allow}" != "true" ] && "echo ${FUNCNAME} fail" && return

  local select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  local tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  if [ "${allow}" = "true" ]; then
    [ "${tag}" = "1" ] && echo "${FUNCNAME} success" && return
  elif [ "${allow}" = "false" ]; then
    [ "${tag}" != "1" ] && echo "${FUNCNAME} success" && return
  fi
 
  cursor_back_home 
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.AIRPLANE_MODE_SETTINGS > /dev/null
  cursor_go 1
  cursor_click

  select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  if [ "${allow}" = "true" ]; then
    [ "${tag}" = "1" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  elif [ "${allow}" = "false" ]; then
    [ "${tag}" != "1" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
  fi
}

###################################################################################
##
###################################################################################
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
    [ "${error}" != "device" ] && echo "$FUNCNAME success" && return 
    sleep 3s
  done
  echo "$FUNCNAME fail"
}

##################################################################################
##
##################################################################################
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
    cursor_up
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
    echo "$FUNCNAME fail" && return
  fi

###Check des wether exist or not ?
#  local check=`adb shell ls ${des} | grep "No such file"`
#  [ "${check}" = "" ] && echo "$FUNCNAME success" && return
  [ -e ${src} ] || 
  {
    echo "$FUNCNAME fail" && return
  }

#Just come to do job
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} remount > /dev/null
  adb -s ${DEVICES_MASTER} push ${src} ${des} > /dev/null 
  sleep 1s

  check=`adb shell ls ${des} | grep "No such file"`
  [ "${check}" = "" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function pc_iperf_c() {
  iperf -c ${PUT_IP_ADDR} -t 30 > /dev/null
  [ "$?" = "0" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function pc_iperf_s() {
  iperf -sD > /dev/null
  [ "$?" = "0" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function dut_iperf_c() {
  local tag=$1
  local arr_rate_Mbit=(`adb shell iperf -c ${PC_IP_ADDR} -i 10 -t 30 -M | grep "Mbits/sec" | awk  -F "MBytes | Mbits/sec" '{ print $2 }'`)
  [ "${arr_rate_Mbit[*]}" = "" ] && echo "$FUNCNAME fail" && return
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
  echo "$FUNCNAME success"
}

function dut_iperf_s() {
  local tag=$1
  local arr_rate_Mbit=(`adb shell iperf -s -i 10 -M | grep "Mbits/sec" | awk  -F "MBytes | Mbits/sec" '{ print $2 }'`)
  [ "${arr_rate_Mbit[*]}" = "" ] && echo "$FUNCNAME fail" && return
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
  echo "$FUNCNAME success"
}

function pc_kill_9_iperf_s() {
  local pids=`ps -aux | grep "iperf -s" | grep [0-9] | awk '{ print $2 }'`
  for pid in ${pids[*]}; do
    kill -9 ${pid} > /dev/null
  done
}

function dut_kill_9_iperf_s() {
  local pids=(`adb shell ps | grep "iperf" | awk '{ print $2 }'`)
  for pid in ${pids[*]}; do
    adb shell kill -9 ${pid} > /dev/null
  done
}

function DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_BG})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c $FUNCNAME)" = "dut_iperf_c success" ] && 
  echo "$FUNCNAME success"
  pc_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_BG})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network fail" ] && return
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  { 
    sleep 5s
    [ "$(pc_iperf_c)" = "pc_iperf_s fail" ] && return || dut_kill_9_iperf_s 
  }&

  [ "$(dut_iperf_s $FUNCNAME)" = "dut_iperf_c success" ]  
  echo "$FUNCNAME success"
}

function DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_A})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c $FUNCNAME)" = "dut_iperf_c success" ] && 
  echo "$FUNCNAME success"
  pc_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_A})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network fail" ] && return
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  { 
    sleep 5s
    [ "$(pc_iperf_c)" = "pc_iperf_s fail" ] && return || dut_kill_9_iperf_s 
  }&

  [ "$(dut_iperf_s $FUNCNAME)" = "dut_iperf_c success" ]  
  echo "$FUNCNAME success"
}

function DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c $FUNCNAME)" = "dut_iperf_c success" ] && 
  echo "$FUNCNAME success"
  pc_kill_9_iperf_s
}

function DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops fail" ] && return

  [ "$(add_network enable_advances=true)" = "add_network fail" ] && return
  [ "$(adb_push src=${PC_IPERF},des=${PUT_IPERF})" = "adb_push success" ] && sleep 3s && 
  { 
    sleep 5s
    [ "$(pc_iperf_c)" = "pc_iperf_s fail" ] && return || dut_kill_9_iperf_s 
  }&

  [ "$(dut_iperf_s $FUNCNAME)" = "dut_iperf_c success" ]  
  echo "$FUNCNAME success"
}

