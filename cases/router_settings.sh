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
#eg: "ssid_24g=wlan_autotest,network_mode_24g=mixed,ssid_broadcast_24g=0"
  local arg=$1
  local user="admin:admin"
  local network_mode_5g=${NETWORK_MODE_MIXED}
  local ssid_5g=${SSID_5G}
  local channel_width_5g=${NETWORK_CHANNEL_WIDTH_AUTO}
  local channel_5g=${NETWORK_CHANNEL_AUTO}
  local ssid_broadcast_5g=${SSID_BROADCAST_ENABLE}
  local network_mode_24g=${NETWORK_MODE_MIXED}
  local ssid_24g=${SSID}
  local channel_width_24g=${NETWORK_CHANNEL_WIDTH_AUTO}
  local channel_24g=${NETWORK_CHANNEL_AUTO}
  local ssid_broadcast_24g=${SSID_BROADCAST_ENABLE}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
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
    "channel_5g")
      channel_5g=${value}
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
    "channel_24g")
      channel_24g=${value}
      ;;
    "passphrase_24g")
      passphrase_24g=${value}
      ;;
    "ssid_broadcast_24g")
      ssid_broadcast_24g=${value}
      ;;
    esac
  done

  if [ "${network_mode_24g}" = "${NETWORK_MODE_DISABLE}" ]; then
    local data="submit_button=Wireless_Basic&action=Apply&submit_type=&change_action=&next_page=&commit=1&wl0_nctrlsb=none&wl1_nctrlsb=none&channel_5g=0&channel_24g=0&nbw_5g=20&nbw_24g=20&wait_time=3&guest_ssid=wlan_autotest-guest&wsc_security_mode=&wsc_smode=1&net_mode_5g=disabled&net_mode_24g=disabled"
  else
    local data="submit_button=Wireless_Basic&action=Apply&submit_type=&change_action=&next_page=&commit=1&wl0_nctrlsb=none&wl1_nctrlsb=none&channel_5g=${channel_5g}&channel_24g=${channel_24g}&nbw_5g=${channel_width_5g}&nbw_24g=${channel_width_24g}&wait_time=3&guest_ssid=wlan111-guest&wsc_security_mode=&wsc_smode=1&net_mode_5g=${network_mode_5g}&ssid_5g=${ssid_5g}&_wl1_nbw=0&_wl1_channel=0&closed_5g=${ssid_broadcast_5g}&net_mode_24g=${network_mode_24g}&ssid_24g=${ssid_24g}&_wl0_channel=0&closed_24g=${ssid_broadcast_24g}"
  fi

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
##Cisco router crypto default value##
#wpa/wpa2 -- "CRYPT_24G_MIXED"
#wpa      -- "CRYPT_24G_TKIP
#wpa2     -- "CRYPT_24G_AES"
  local crypto_24g="tkip%2Baes"
  local crypto_5g="tkip%2Baes"
  local encypt_wep='64'

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "security_mode_24g")
      security_mode_24g=${value}
      ;;
    "passphrase_24g")
      passphrase_24g=${value}
      ;;
    "crypto_24g")
      crypto_24g=${value}
      ;;
    "security_mode_5g")
      security_mode_5g=${value}
      ;;
    "passphrase_5g")
      passphrase_5g=${value}
      ;;
    "crypto_5g")
      crypto_5g=${value}
      ;;
    "encypt_wep")
      encypt_wep=${value}
      ;;
    esac
  done

 case ${security_mode_24g} in
   "${SECURT_MODE_WPA_WPA2}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=${passphrase_24g}&wsc_nwkey1=${passphrase_5g}&wl0_crypto=tkip%2Baes&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=${passphrase_5g}&wl0_security_mode=wpa2_personal&wl0_wpa_psk=${passphrase_24g}"
     ;;
   "${SECURT_MODE_WPA2_PERSONAL}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=${passphrase_24g}&wsc_nwkey1=${passphrase_5g}&wl0_crypto=aes&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=${passphrase_5g}&wl0_security_mode=wpa2_personal&wl0_wpa_psk=${passphrase_24g}"
     ;;
   "${SECURT_MODE_WPA_PERSONAL}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=${passphrase_24g}&wsc_nwkey1=${passphrase_5g}&wl0_crypto=tkip&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=${passphrase_5g}&wl0_security_mode=wpa_personal&wl0_wpa_psk=${passphrase_24g}"
     ;;
   "${SECURT_MODE_ENTERPRISE_MIXED_MODE}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=${passphrase_24g}&wsc_nwkey1=${passphrase_5g}&wl0_crypto=tkip%2Baes&wl1_crypto=tkip%2Baes%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=${passphrase_5g}&wl0_security_mode=wpa2_personal&wl0_radius_ipaddr=4&wl0_radius_ipaddr_0=192&wl0_radius_ipaddr_1=168&wl0_radius_ipaddr_2=1&wl0_radius_ipaddr_3=120&wl0_radius_port=1812&wl0_radius_key=${passphrase_24g}"
     ;;
   "${SECURT_MODE_WPA2_ENTERPRISE}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=12345678&wsc_nwkey1=987654321&wl0_crypto=aes&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=987654321&wl0_security_mode=wpa2_enterprise&wl0_radius_ipaddr=4&wl0_radius_ipaddr_0=192&wl0_radius_ipaddr_1=168&wl0_radius_ipaddr_2=1&wl0_radius_ipaddr_3=121&wl0_radius_port=1812&wl0_radius_key=12345678"
     ;;
   "${SECURT_MODE_WPA_ENTERPRISE}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=12345678&wsc_nwkey1=987654321&wl0_crypto=tkip&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=987654321&wl0_security_mode=wpa_enterprise&wl0_radius_ipaddr=4&wl0_radius_ipaddr_0=192&wl0_radius_ipaddr_1=168&wl0_radius_ipaddr_2=1&wl0_radius_ipaddr_3=121&wl0_radius_port=1812&wl0_radius_key=12345678"
     ;;
   "${SECURT_MODE_WEP}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=${passphrase_24g}&wsc_nwkey1=987654321&wl0_crypto=tkip&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=987654321&wl0_security_mode=wep&wl0_wep_bit=${encypt_wep}&wl0_passphrase=&generateButton0=Null&wl0_key1=${passphrase_24g}&wl0_WEP_key=&wl0_wep=restricted&wl0_key=1"
     ;;
   "${SECURT_MODE_RADIUS}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=12345678&wsc_nwkey1=987654321&wl0_crypto=tkip&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=987654321&wl0_security_mode=radius&wl0_radius_ipaddr=4&wl0_radius_ipaddr_0=192&wl0_radius_ipaddr_1=168&wl0_radius_ipaddr_2=1&wl0_radius_ipaddr_3=121&wl0_radius_port=1812&wl0_radius_key=12345678&wl0_wep_bit=64&wl0_passphrase=&generateButton0=Null&wl0_key2=1234567890&wl0_WEP_key=&wl0_wep=restricted&wl0_key=2"
     ;;
   "${SECURT_MODE_DISABLE}")
     local data="submit_button=WL_WPATable&change_action=&submit_type=&action=Apply&security_mode_last=&wl_wep_last=&wait_time=3&wsc_nwkey0=&wsc_nwkey1=987654321&wl0_crypto=tkip&wl1_crypto=tkip%2Baes&wsc_security_auto=0&wl1_security_mode=wpa2_personal&wl1_wpa_psk=987654321&wl0_security_mode=disabled"
     ;;
  esac

  curl --user $user --data "$data" http://192.168.1.1/apply.cgi  > /dev/null
  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

function Basic_Setup() {
  local arg=$1
  local user="admin:admin"
  local lan_proto=${DHCP_SERVER_ENABLE}

  [ "${arg}" != "" ] &&
  for i in 1; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "lan_proto")
      lan_proto=${value}
      ;;
    esac
  done

  case ${lan_proto} in
    "${DHCP_SERVER_DISABLE}")
      local data="submit_button=index&change_action=&submit_type=&action=Apply&now_proto=dhcp&daylight_time=1&switch_mode=0&hnap_devicename=Cisco16206&need_reboot=0&user_language=&wait_time=0&dhcp_start=100&dhcp_start_conflict=0&lan_ipaddr=4&ppp_demand_pppoe=9&ppp_demand_pptp=9&ppp_demand_l2tp=9&ppp_demand_hb=9&wan_ipv6_proto=dhcp&detect_lang=en&wan_proto=dhcp&wan_hostname=&wan_domain=&mtu_enable=0&lan_ipaddr_0=192&lan_ipaddr_1=168&lan_ipaddr_2=1&lan_ipaddr_3=1&lan_netmask=255.255.255.0&machine_name=Cisco16206&lan_proto=static&time_zone=-08+1+1&_daylight_time=1"
  ;;
  "${DHCP_SERVER_ENABLE}")
    local data="submit_button=index&change_action=&submit_type=&action=Apply&now_proto=dhcp&daylight_time=1&switch_mode=0&hnap_devicename=Cisco16206&need_reboot=0&user_language=&wait_time=0&dhcp_start=100&dhcp_start_conflict=0&lan_ipaddr=4&ppp_demand_pppoe=9&ppp_demand_pptp=9&ppp_demand_l2tp=9&ppp_demand_hb=9&wan_ipv6_proto=dhcp&detect_lang=en&wan_proto=dhcp&wan_hostname=&wan_domain=&mtu_enable=0&lan_ipaddr_0=192&lan_ipaddr_1=168&lan_ipaddr_2=1&lan_ipaddr_3=1&lan_netmask=255.255.255.0&machine_name=Cisco16206&lan_proto=dhcp&dhcp_check=&dhcp_start_tmp=100&dhcp_num=50&dhcp_lease=0&wan_dns=4&wan_dns0_0=0&wan_dns0_1=0&wan_dns0_2=0&wan_dns0_3=0&wan_dns1_0=0&wan_dns1_1=0&wan_dns1_2=0&wan_dns1_3=0&wan_dns2_0=0&wan_dns2_1=0&wan_dns2_2=0&wan_dns2_3=0&wan_wins=4&wan_wins_0=0&wan_wins_1=0&wan_wins_2=0&wan_wins_3=0&time_zone=-08+1+1&_daylight_time=1"
  ;;
  esac

  curl --user $user --data "$data" http://192.168.1.1/apply.cgi  > /dev/null

  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

function WiFi_Protected_Setup() {
  local arg=$1
  local user="admin:admin"
  local wps_enable=false
  local wps_button_tap=false
  local wps_pin_num=""
  local data=""

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
    "wps_enable")
      wps_enable=${value}
      ;;
    "wps_button_tap")
      wps_button_tap=${value}
      ;;
    "wps_pin_num")
      wps_pin_num=${value}
      ;;
    esac
  done
  
  if [ "${wps_enable}" = 'true' ] && [ "${wps_button_tap}" = 'true' ]; then
    data="submit_button=Wireless_Basic&action=&commit=&pbutton=0&submit_type=wsc_method1&wsc_security_mode=&wsc_enr_pin=&change_action=gozila_cgi&next_page=Wireless_Basic.asp&wsc_result=3&wsc_guiresult=&wsc_barwidth=&wsc_smode=1&wsc_mode=0"
  fi

  curl --user ${user} --data "${data}" http://192.168.1.1/apply.cgi > /dev/null
  if [ $? -eq 0 ] ; then
    echo "$FUNCNAME success"
  else
    echo "$FUNCNAME fail"
  fi
}

function set_ap_ops() {
  local arg=$1

#Basic_Wireless_Settings :
  local network_mode_5g=${NETWORK_MODE_MIXED}
  local ssid_5g=${SSID_5G}
  local channel_width_5g=${NETWORK_CHANNEL_WIDTH_AUTO}
  local channel_5g=${NETWORK_CHANNEL_AUTO}
  local ssid_broadcast_5g=${SSID_BROADCAST_ENABLE}
  local network_mode_24g=${NETWORK_MODE_MIXED}
  local ssid_24g=${SSID}
  local channel_width_24g=${NETWORK_CHANNEL_WIDTH_AUTO}
  local channel_24g=${NETWORK_CHANNEL_AUTO}
  local ssid_broadcast_24g=${SSID_BROADCAST_ENABLE}

#Wireless_Security :
  local security_mode_5g=${SECURT_MODE_WPA_WPA2}
  local passphrase_5g=${SSID_PASSWORD}
  local security_mode_24g=${SECURT_MODE_WPA_WPA2}
  local passphrase_24g=${SSID_PASSWORD}
  local encypt_wep='64'
#Basic Setup
  local lan_proto=${DHCP_SERVER_ENABLE}

#WPS :
  local wps_enable=false
  local wps_button_tap=false
  local wps_pin_num=""

#others:
  local func=${FUNCNAME}
  local crypto_24g=${CRYPT_24G_MIXED}
  local crypto_5g=${CRYPT_5G_MIXED}

  [ "${arg}" != "" ] &&
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23; do
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
    "channel_5g")
      channel_5g=${value}
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
    "channel_24g")
      channel_24g=${value}
      ;;
    "passphrase_24g")
      channel_24g=${value}
      ;;
    "ssid_broadcast_24g")
      ssid_broadcast_24g=${value}
      ;;
    "security_mode_5g")
      security_mode_5g=${value}
      ;;
    "crypto_5g")
      crypto_5g=${value}
      ;;
    "passphrase_5g")
      passphrase_5g=${value}
      ;;
    "security_mode_24g")
      security_mode_24g=${value}
      ;;
    "crypto_24g")
      crypto_24g=${value}
      ;;
    "passphrase_24g")
      passphrase_24g=${value}
      ;;
    "encypt_wep")
      encypt_wep=${value}
      ;;
    "lan_proto")
     lan_proto=${value}
     ;;
    "wps_enable")
      wps_enable=${value}
      ;;
    "wps_button_tap")
      wps_button_tap=${value}
      ;;
    "wps_pin_num")
     wps_pin_num=${value}
     ;;
    "func")
     func=${value}
     ;;
  esac
  done

  if [ "$(Basic_Wireless_Settings network_mode_24g=${network_mode_24g},ssid_24g=${ssid_24g},channel_width_24g=${channel_width_24g},channel_24g=${channel_24g},ssid_broadcast_24g=${ssid_broadcast_24g},network_mode_5g=${network_mode_24g},ssid_5g=${ssid_5g},channel_width_5g=${channel_width_5g},channel_5g=${channel_5g},ssid_broadcast_5g=${ssid_broadcast_5g})" = "Basic_Wireless_Settings fail" ]; then
    echo "${FUNCNAME} fail" && opt_fail ${func} && return
  fi

  sleep 3s

  if [ "$(Wireless_Security security_mode_24g=${security_mode_24g},passphrase_24g=${security_mode_24g},security_mode_5g=${security_mode_5g},passphrase_24g=${passphrase_24g},crypto_24g=${crypto_24g},crypto_5g=${crypto_5g},encypt_wep=${encypt_wep})" = "Wireless_Security fail" ]; then
    echo "${FUNCNAME} fail"  &&  opt_fail ${func} && return
  fi

  sleep 3s

  if [ "$(Basic_Setup lan_proto=${lan_proto})" = "Basic_Setup fail" ]; then
    echo "${FUNCNAME} fail" && opt_fail ${func} && return
  fi

  if [ "$(WiFi_Protected_Setup wps_enable=${wps_enable},wps_button_tap=${wps_button_tap},wps_pin_num=${wps_pin_num})" = "WiFi_Protected_Setup fail" ]; then
    echo "${FUNCNAME} fail" && opt_fail ${func} && return
  fi

  sleep 10s

  echo "${FUNCNAME} success"
}

#For debug
#set_ap_ops network_mode_24g=${NETWORK_MODE_MIXED},channel_width_24g=${NETWORK_CHANNEL_WIDTH_AUTO},channel_24g=${NETWORK_CHANNEL_11},security_mode_24g=${SECURT_MODE_WPA_WPA2},passphrase_24g="12345678",lan_proto=${DHCP_SERVER_ENABLE}
