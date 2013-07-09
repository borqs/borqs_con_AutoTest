#!/bin/bash


function adb_wpa_cli_ping() {
    for((i=0;i<3;i++)); do
    local res=`adb -s ${DEVICES_MASTER} shell wpa_cli ping | grep PONG | awk '{print substr($1,1,4)}'`
    if [ "$res" = "PONG" ]; then
      echo "$FUNCNAME success"
      break
    else
      [ "$i" = "2" ]  && echo "$FUNCNAME fail"
    fi  
  done
}

function pc_ping_ap(){
  for((i=0; i<3; i++)); do  
    local res=`ping -c 3 -i 0.5 $PC_IP_ADDR | grep packet | awk -F ", " '{print $3}'`
    if [ "$res" = "0% packet loss" ] ; then
      echo "$FUNCNAME success"
      break
    else
      [ "$i" = "2" ] && echo "pc_ping_ap fail"
    fi  
  done
}


function adb_ping(){
  for((i=0; i<3; i++)); do
    local res=`adb -s ${DEVICES_MASTER} shell ping -c 2 -i 0.5 $AP_IP_ADDR | grep packet |awk -F ", " '{print $3}'`
    if [ "$res" = "0% packet loss" ] ; then
      echo "$FUNCNAME success"
      break
    else
      [ "$i" = "2" ] && echo "$FUNCNAME fail"
    fi
  done
}


function adb_wpa_cli_bssid_status(){
  local bssid=${BSSID}
  sleep 10s
  local res=`adb -s ${DEVICES_MASTER} shell wpa_cli status | grep bssid | awk -F "=" '{print substr($2,1,17)}'`
  if [ "$res" = "$bssid" ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}


###################################################################################################
## eg: adb_screencap png=0_0.png
###################################################################################################
function adb_screencap() {
  local png_name=`echo $1 | grep "png" | awk -F "=" '{print $2}'`
  local pc_png_path="$(pwd)/results/png/${png_name}"
  local dut_png_path="/data/${png_name}"

  adb -s ${DEVICES_MASTER} shell screencap ${dut_png_path} > /dev/null 
  sleep 3s
  adb -s ${DEVICES_MASTER} pull ${dut_png_path} ${pc_png_path} > /dev/null

  if [ -e ${pc_png_path} ] ;then 
    echo "$FUNCNAME success"
  else 
    echo "$FUNCNAME fail"
  fi
}

