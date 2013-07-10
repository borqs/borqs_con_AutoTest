#!/bin/bash

################################################################################
##operations for cursor
################################################################################
function reset_cursor_to_top() {
  for((i=0; i<10; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 19
  done
  sleep 1s
}

function reset_cursor_to_top_20() {
  for((i=0; i<20; i++)); do
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

function reset_cursor_to_bottom_20() {
  for((i=0; i<20; i++)); do
    adb -s ${DEVICES_MASTER} shell input keyevent 20
  done
  sleep 1s
}

function cursor_back_home() {
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
  reset_cursor_to_top
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
    adb -s ${DEVICES_MASTER} shell input touchscreen tap 300 190
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
    adb -s ${DEVICES_MASTER} shell input touchscreen tap 300 190
    sleep 2s
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ] &&
    echo "$FUNCNAME success" && cursor_click && return
  done

  echo "$FUNCNAME fail"
}

#####################################################################################
##basic operations: add network, connect first ssid in list, manual scan
##                  forget connected ssid.
##################################################################################### 
#secType None          ->   0
#secType WEP           ->   1
#secType WPA/WPA2 PSK  ->   2
#secType 802.x EAP     ->   3
function add_network() {
  local arg=$1
  local ssid=${SSID}
  local mode=${SECURT_MODE_WPA_WPA2}
  local password=${SSID_PASSWORD}
  local show_password=false
  local password_png="${FUNCNAME}_password.png"
  local show_advances=false
  local enable_advances=false
  local advances_png="${FUNCNAME}_advances.png"
  local ip_address=${DUT_IP_ADDR}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9; do 
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in  
    "ssid")
      ssid=${value}
      ;;  
    "mode")
      mode=${value}
      ;;  
    "password")
      password=${value}
      ;;
    "show_password")
      show_password=${value}
      ;;
    "password_png")
      password_png=${value}
      ;;
    "show_advances")
      show_advances=${value}
      ;;
    "enable_advances")
      enable_advances=${value}
      ;;
    "advances_png")
      advances_png=${value}
      ;;
    "ip_address")
      ip_address=${value}
      ;;
    esac
  done

#open add network
  cursor_back
  if [ "$(open_wifi)" = "open_wifi fail" ] ; then
    echo "${FUNCNAME} fail"
    return
  fi
#add network
  adb -s ${DEVICES_MASTER} shell input touchscreen tap 435 765 
  sleep 1s
#input ssid
  reset_cursor_to_top
  adb -s ${DEVICES_MASTER} shell input text ${ssid}
  cursor_down 
#mode
  cursor_click
  reset_cursor_to_top
  if [ "${mode}" = "${SECURT_MODE_NONE}" ]; then
  #select none
    cursor_click
  
  
    if [ "${show_password}" = "true" ]; then
      cursor_click
      [ "$(adb_screencap png=${password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi

  elif [ "${mode}" = "${SECURT_MODE_WEP}" ]; then
    cursor_down
    cursor_click

    cursor_down

  #password
    adb -s ${DEVICES_MASTER} shell input text ${password}
    cursor_down

  #show password and do screen captrue
    if [ "${show_password}" = "true" ]; then
      cursor_click
      [ "$(adb_screencap png=${password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi

  elif [ "${mode}" = "${SECURT_MODE_WPA_WPA2}" ]; then
  #select wpa2
    cursor_down
    cursor_down
    cursor_click
    
    cursor_down

  #password
    adb -s ${DEVICES_MASTER} shell input text ${password}
    cursor_down

  #show password and do screen captrue
    if [ "${show_password}" = "true" ]; then
      cursor_click
      [ "$(adb_screencap png=${password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
    fi

  else
    echo "$FUNCNAME fail" && return
  fi

  if [ "${enable_advances}" = "true" ]; then
  #show advaces
    cursor_down
    cursor_click

  #Static IP
    cursor_down
    cursor_down

    if [ "${show_advances}" = "true" ]; then
      [ "$(adb_screencap png=${advances_png})" = "adb_screencap fail" ] && echo "${FUNCNAME} fail" && return
    fi

    cursor_click
    cursor_up
    cursor_down
    cursor_click
    sleep 1s
 
  #IP ADDR
    cursor_down
    adb -s ${DEVICES_MASTER} shell input text ${ip_address}

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
  local password=${SSID_PASSWORD}
  local show_password="false"
  local password_png="${FUNCNAME}_password.png"
  local show_advances="false"
  local advances_png="${FUNCNAME}_advances.png"
  local enable_advances="false"
  local ip_address="${DUT_IP_ADDR}"

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7; do 
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in 
    "password")
      password=${value}
      ;; 
    "show_password")
      show_password=${value}
      ;;  
    "password_png")
      password_png=${value}
      ;;
    "show_advances")
      show_advances=${value}
      ;;
    "enable_advances")
      enable_advances=${value}
      ;;
    "advances_png")
      advances_png=${value}
      ;;
    "ip_address")
      ip_address=${value}
      ;;
    esac
  done

#If had been connected, it just forget it !
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
  reset_cursor_to_top
  cursor_down
  cursor_click
  sleep 1s

#input password
  adb -s ${DEVICES_MASTER} shell input text ${password}
  sleep 1s

  cursor_down

#show password and do screen captrue
  if [ "${show_password}" = "true" ]; then
    cursor_click
    [ "$(adb_screencap png=${password_png})" = "adb_screencap fail" ] && cursor_back && echo "${FUNCNAME} fail" && return
  fi

  if [ "${enable_advances}" = "true" ]; then
  #show advaces
    cursor_down
    cursor_click
    
    if [ "${show_advances}" = "true" ]; then
      [ "$(adb_screencap png=${advances_png})" = "adb_screencap fail" ] && echo "${FUNCNAME} fail" && return
    fi

  #Static IP
    cursor_down
    cursor_down

    cursor_click
    cursor_up
    cursor_down
    cursor_click
   
  #IP ADDR
    adb -s ${DEVICES_MASTER} shell input text ${ip_address}

  ##Gateway
    cursor_down

  #Network length
    cursor_down

  #DNS1
    cursor_down

  #DNS2
    adb -s ${DEVICES_MASTER} shell input text "8.8.4.4"
   fi

#do connect
  reset_cursor_to_bottom 
  cursor_click
  sleep 15s

#check results
  if [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

###########################################################################################
##
###########################################################################################
function forget_first_ssid() {
  if [ "$(adb_ping)" = "adb_ping fail" ]; then
    echo "$FUNCNAME success"
    return
  fi

#come to wifi setting, touch first ssid, forget
  if [ "$(open_wifi)" = "open_wifi success" ]; then
    reset_cursor_to_top
    cursor_down
    cursor_click
    reset_cursor_to_bottom
    cursor_click
    sleep 3s
  fi

  if [ "$(adb_ping)" = "adb_ping fail" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

####################################################################################
##clean wifi operations:
####################################################################################
function clean_wifi_operations() {
#forget 
  cursor_back 
  if [ "$(adb_ping)" = "adb_ping success" ] ; then
    [ "$(forget_first_ssid)" = "forget_first_ssid fail" ] &&
    [ "$(forget_first_ssid)" = "forget_first_ssid fail" ] &&
    [ "$(forget_first_ssid)" = "forget_first_ssid fail" ] &&
    echo "$FUNCNAME fail" &&
    return
  fi

#close
  if [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ]; then
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    [ "$(close_wifi)" = "close_wifi fail" ] &&
    echo "$FUNCNAME fail" &&
    return
  fi

#back home
  cursor_back_home
  echo "$FUNCNAME success"
}


####################################################################################
##eg: browser_load_web 
#####################################################################################
function browser_load_web() {
  local arg=$1
  local http=`echo $arg | grep "http=" | awk -F "," '{ print $1 }' | awk -F "=" '{ print $2} '`
  local png=`echo $arg | grep "png=" | awk -F "," '{ print $2 }' | awk -F "=" '{ print $2} '`
  
  if [ ${http} = "" ] || [ ${png} = "" ]; then
    echo "$FUNCNAME fail"
    return
  fi

  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.intent.action.VIEW -d "${http}" > /dev/null
  sleep 5s
  if [ "$(adb_screencap png=${png})" = "adb_screencap success" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

####################################################################################
##eg: download_data_via_browser file_name=http://www.*******
####################################################################################
function download_data_via_browser() {
  local arg=$1
  local http=`echo ${arg} | grep "http=" | awk -F "," '{ print $1 }' | awk -F "=" '{ print $2 }'`
  local file_name=`echo ${arg} | grep "file_name=" | awk -F "," '{ print $2 }' | awk -F "=" '{ print $2 }'`
  local file_path_name="${DUT_DOWNLOAD_DIR}/${file_name}"

  if [ "${file_name}" = "" ] || [ "${http}" = "" ] ;then
    echo "$FUNCNAME fail"
    return
  fi

  cursor_back_home
  adb -s ${DEVICES_MASTER} remount > /dev/null
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} push ${CURL} /system/bin/ > /dev/null
  adb -s ${DEVICES_MASTER} shell curl -o ${file_path_name} ${http} > /dev/null
  sleep 3s
  adb -s ${DEVICES_MASTER} pull ${file_path_name} ${DOWNLOAD_DIR}/${file_name} > /dev/null
 
  if [ -e "${DOWNLOAD_DIR}/${file_name}" ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi 
}

#####################################################################################
##
#####################################################################################
function reload_wpa_supplicant_conf() {
  local wpa_conf=${WPA_SUPPLICANT_CONF}
  local arg=$1
 
  if [ ${arg} != "" ]; then
    wpa_conf=`echo ${arg} | grep "wpa_conf=" | awk -F "=" '{ print $2 }'`
  fi  
 
  adb -s ${DEVICES_MASTER} remount > /dev/null
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} shell rm /data/misc/wifi/wpa_supplicant.conf > /dev/null
  local ver=`adb -s ${DEVICES_MASTER} shell ls /data/misc/wifi/wpa_supplicant.conf | grep "No such file or directory"`
  [ "${ver}" = "" ] && echo "$FUNCNAME fail" && return 
 
  adb -s ${DEVICES_MASTER} push ${wpa_conf} /data/misc/wifi/wpa_supplicant.conf > /dev/null
  sleep 2s
  ver=`adb -s ${DEVICES_MASTER} shell ls /data/misc/wifi/wpa_supplicant.conf | grep "No such file or directory"`
  if [ "${ver}" = "" ]; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}


#################################################################################
##
#################################################################################
function enable_airplane() {
  local select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  local tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  if [ "${tag}" != "1" ]; then
    cursor_back_home 
    adb -s ${DEVICES_MASTER} shell am start -a android.settings.AIRPLANE_MODE_SETTINGS > /dev/null
    reset_cursor_to_top
    cursor_down
    cursor_click 
    select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
    tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`
  fi

  if [ "${tag}" = "1" ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

#################################################################################
##
#################################################################################
function disable_airplane() {
  local select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
  local tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`

  if [ "${tag}" = "1" ]; then
    cursor_back_home 
    adb -s ${DEVICES_MASTER} shell am start -a android.settings.AIRPLANE_MODE_SETTINGS > /dev/null
    reset_cursor_to_top
    cursor_down
    cursor_click 
    select=`adb -s ${DEVICES_MASTER} shell sqlite3  /data/data/com.android.providers.settings/databases/settings.db "select * from global where name = 'airplane_mode_on';"`
    tag=`echo ${select} | grep "airplane_mode_on" | awk -F "|" '{ print substr($3,1,1) }'`
  fi

  if [ "${tag}" = "0" ] || [ "${tag}" = "" ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
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
function screen_captrue_IP_MAC() {
  local arg=$1

  cursor_back_home
  adb -s ${DEVICES_MASTER} shell am start -a android.settings.WIFI_IP_SETTINGS > /dev/null
  sleep 3s

  if [ "$(adb_screencap ${arg})" = "adb_screencap success" ] ;then
    echo "${FUNCNAME} success"
  else 
    echo "${FUNCNAME} fail"
  fi
  cursor_back
}

###################################################################################
##
###################################################################################
function screen_captrue_last_ssid() {
  local arg=$1

  if [ "$(open_wifi)" = "open_wifi fail" ]; then 
    echo "$FUNCNAME fail"
    return
  fi

  reset_cursor_to_bottom_20
  cursor_up
  cursor_click
  sleep 3s

  if [ "$(adb_screencap ${arg})" = "adb_screencap success" ] ;then
    echo "${FUNCNAME} success"
  else 
    echo "${FUNCNAME} fail"
  fi
  reset_cursor_to_top_20
  cursor_back
}


function screen_captrue_first_ssid() {
  local arg=$1

  if [ "$(open_wifi)" = "open_wifi fail" ]; then 
    echo "$FUNCNAME fail"
    return
  fi
  if [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] ;then
    echo "$FUNCNAME fail"
    return
  fi

  reset_cursor_to_top
  cursor_down
  cursor_click
  sleep 3s

  if [ "$(adb_screencap ${arg})" = "adb_screencap success" ] ;then
    echo "${FUNCNAME} success"
  else 
    echo "${FUNCNAME} fail"
  fi
  cursor_back
}

function screen_captrue_ssid() {
  local arg=$1

  [ "$(open_wifi)" = "open_wifi fail" ] && echo "${FUNCNAME} fail" && return
  sleep 3s
  [ "$(adb_screencap ${arg})" = "adb_screencap success" ] && echo "${FUNCNAME} success" || echo "${FUNCNAME} fail"
}

function adb_push_iperf() {
###push iperf
  local check_iperf=`adb shell ls /system/bin/iperf | grep "No such file"`
  [ "${check_iperf}" = "" ] && echo "$FUNCNAME success" && return

  [ -e ${IPERF} ] || ( echo "$FUNCNAME fail" && return )
  adb -s ${DEVICES_MASTER} root > /dev/null
  adb -s ${DEVICES_MASTER} remount > /dev/null
  adb -s ${DEVICES_MASTER} push ${IPERF} /system/bin/iperf > /dev/null 
  sleep 1s

  local no_iperf=`adb shell ls /system/bin/iperf | grep "No such file"`
  [ "${no_iperf}" = "" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function pc_iperf_c() {
  iperf -c ${DUT_IP_ADDR} -t 180 > /dev/null
  [ "$?" = "0" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function pc_iperf_s() {
  iperf -sD > /dev/null
  [ "$?" = "0" ] && echo "$FUNCNAME success" || echo "$FUNCNAME fail"
}

function dut_iperf_c() {
  local tag=$1
  local arr_rate_Mbit=(`adb shell iperf -c ${PC_IP_ADDR} -i 10 -t 180 -M | grep "Mbits/sec" | awk  -F "MBytes | Mbits/sec" '{ print $2 }'`)
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
