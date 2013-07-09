#!/bin/bash

################################################################################################
##Basic Wireless Settings: 
##Default:  
##5G Network Mode: mixed
##5G SSID: wlan_autotest_5G
##5G Channel Width: Auto
##5G Channel: AUto
##5G SSID Broadcast: Enable
##2.4G Network Mode: mixed
##2.4G SSID: wlan_autotest
##2.4G Channel Width: Auto
##2.4G Channel: AUto
##2.4G SSID Broadcast: Enable
################################################################################################
function Basic_Wireless_Settings() {
#eg: "ssid_24g=wlan_autotest, network_mode_24g=mixed, ssid_broadcast_24g=0"
  local arg=$1
  local user="admin:admin"
  local network_mode_5g="mixed"
  local ssid_5g=${SSID_5G}
  local channel_width_5g="0"
  local channel_5g="0"
  local ssid_broadcast_5g="0"
  local network_mode_24g="mixed"
  local ssid_24g=${SSID}
  local channel_width_24g="0"
  local channel_24g="0"
  local ssid_broadcast_24g="0"



  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 ;do 
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in 
    "network_mode_5g")
      network_mode_5g=${value}
      ;;
    "ssid_5g")
      ssid_5g=${value}
      ;;
    "channel_width_5g")
      channel_width_5g=${value}
      ;;
    "passphrase_5g")
      channel_5g=${value}
      ;;
    "ssid_broadcast_5g")
      ssid_broadcast_5g=${value}
      ;;
    "network_mode_24g")
      network_mode_24g=${value}
      ;;
    "ssid_24g")
      ssid_24g=${value}
      ;;
    "channel_width_24g")
      channel_width_24g=${value}
      ;;
    "passphrase_24g")
      channel_24g=${value}
      ;;
    "ssid_broadcast_24g")
      ssid_broadcast_24g=${value}
      ;;
    esac
  done

  local data="submit_button=Wireless_Basic&action=Apply&submit_type=&change_action=&next_page=&commit=1&wl0_nctrlsb=none&wl1_nctrlsb=none&channel_5g=${channel_5g}&channel_24g=${channel_24g}&nbw_5g=${channel_width_5g}&nbw_24g=${channel_width_24g}&wait_time=3&guest_ssid=wlan111-guest&wsc_security_mode=&wsc_smode=1&net_mode_5g=${network_mode_5g}&ssid_5g=${ssid_5g}&_wl1_nbw=0&_wl1_channel=0&closed_5g=${ssid_broadcast_5g}&net_mode_24g=${network_mode_24g}&ssid_24g=${ssid_24g}&_wl0_channel=0&closed_24g=${ssid_broadcast_24g}"
  
  curl --user $user --data "$data" http://192.168.1.1/apply.cgi  > /dev/null
  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"  
  fi
}

######################################################################################################
### Wireless Security :
#######################################################################################################
function Wireless_Security() {
#eg: "security_mode_24g=wpa2_personal, passphrase_24g=12345678"
  local arg=$1
  local user="admin:admin"
  local security_mode_5g=${SECURT_MODE_WPA_WPA2}
  local passphrase_5g=${SSID_PASSWORD}
  local security_mode_24g=${SECURT_MODE_WPA_WPA2}
  local passphrase_24g=${SSID_PASSWORD}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 ;do 
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in 
    "security_mode_24g")
      security_mode_24g=${value}
      ;;
    "passphrase_24g")
      passphrase_24g=${value}
      ;;
    "security_mode_5g")
      security_mode_5g=${value}
      ;;
    "passphrase_5g")
      passphrase_5g=${value}
      ;;
    esac
  done

  if [ "${security_mode_24g}" = "${SECURT_MODE_WEP}" ]; then
    local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=1234567890&wsc_nwkey1=12345678&wl0_crypto=tkip%2Baes&wl1_crypto=aes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=12345678&wl0_security_mode=${security_mode_24g}&wl0_wep_bit=64&wl0_passphrase=&generateButton0=Null&wl0_key1=${passphrase_24g}&wl0_WEP_key=&wl0_wep=restricted&wl0_key=1"
  else
    local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=000000000&wsc_nwkey1=11111111&wl0_crypto=tkip%2Baes&wl1_crypto=aes&wsc_security_auto=0&wl1_security_mode=${security_mode_5g}&wl1_wpa_psk=${passphrase_5g}&wl0_security_mode=${security_mode_24g}&wl0_wpa_psk=${passphrase_24g}"
  fi

  curl --user $user --data "$data" http://192.168.1.1/apply.cgi  > /dev/null
  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"  
  fi
}
########################################################################################################
## Default SSID settings:
########################################################################################################
function Setting_Default_SSID() {
  [ "$(Basic_Wireless_Settings)" = "Basic_Wireless_Settings fail" ] &&
  [ "$(Basic_Wireless_Settings)" = "Basic_Wireless_Settings fail" ] &&
  [ "$(Basic_Wireless_Settings)" = "Basic_Wireless_Settings fail" ] &&
  echo "$FUNCNAME fail" && return

  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  echo "$FUNCNAME fail" && return

  echo "$FUNCNAME success"
}

######################################################################################################
###
######################################################################################################
function Click_WiFi_Protected_Setup_Button() {
  local user="admin:admin"
  local data="submit_button=Wireless_Basic&action=&commit=&pbutton=0&submit_type=wsc_method1&wsc_security_mode=&wsc_enr_pin=&change_action=gozila_cgi&next_page=Wireless_Basic.asp&wsc_result=3&wsc_guiresult=&wsc_barwidth=&wsc_smode=1&wsc_mode=0"

  curl --user ${user} --data "${data}" http://192.168.1.1/apply.cgi > /dev/null
  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"  
  fi
}

######################################################################################################
###
######################################################################################################
function disable_DHCP_and_setting_default_SSID() {
  echo "${FUNCNAME} success"
}
