#/bin/bash

######################################################################################
###Here are the Global Variable Parameters
######################################################################################
#export DEVICES_MASTER="45010053454d30384790061f1a2230ab"
export DEVICES_MASTER="45010053454d30384790061f1a2230ab"
export DEVICES_SLAVE=""
export SSID="wlan_autotest"
export SSID_5G="wlan_autotest_5G"
export SSID_PASSWORD="12345678"
export SECURT_MODE_WPA_WPA2="wpa2_personal"
export SECURT_MODE_WEP="wep"
export SECURT_MODE_NONE="none"
export SSID_PASSWORD_WEP="1234567890"
export BSSID="58:6d:8f:85:cf:56"
export AP_IP_ADDR="192.168.1.1"
export PC_IP_ADDR="192.168.1.222"
export DUT_IP_ADDR="192.168.1.111"
export NEW_BAIDU="http://192.168.1.222/index.html"
export MP3="http://192.168.1.222/test/Beijing_Beijing.mp3"
export DUT_DOWNLOAD_DIR="/data"
export PC_DOWNLOAD_DIR="$(pwd)/results/download"
export PNG="$(pwd)/results/png"
export WPA_SUPPLICANT_CONF="$(pwd)/prepared/wpa_supplicant.conf"
export CURL="$(pwd)/prepared/bin/curl"
export IPERF="$(pwd)/prepared/bin/iperf_arm"
export OK_FAIL="$(pwd)/results/OK_FAIL.txt"
export DATA_THROUGHPUT="$(pwd)/results/RT.txt"
export CASE_INFO="$(pwd)/results/cases_info"

######################################################################################
###dut_operations.sh   :     do operations in DUT part
###tp_link_settings.sh :     do settings in AP part
###verifications.sh    :     check results (screen capture, wpa_cli)
######################################################################################
source $(pwd)/cases/dut_operations.sh
source $(pwd)/cases/tp_link_settings.sh
source $(pwd)/cases/verifications.sh

#####################################################################################
###Clean last test results
######################################################################################
[ -e ${OK_FAIL} ] && rm ${OK_FAIL} && echo "${OK_FAIL} clean"
[ -e ${PC_DOWNLOAD_DIR}/* ] && rm -rf ${PC_DOWNLOAD_DIR}/* && echo "${PC_DOWNLOAD_DIR}/* clean"
[ -e ${PNG}/* ] && rm -rf ${PNG}/* && echo "${PNG}/* clean"
[ -e ${CASE_INFO}/* ] && rm -rf ${CASE_INFO}/* && echo "${CASE_INFO}/* clean"

######################################################################################
###Here are the cases, which could be set enable or disable in config.txt file
######################################################################################

######################################################################################
###Part 1 :    Basic function of wifi UI
######################################################################################

###PFT-2511 Browser internet  via connect wifi 
##Init  : Be Connected
##Step  : Browser can load http://news.baidu.com/
##Check : Screen capture
function PFT_2511_Browser_internet_via_connect_wifi() {
  echo " " >> $OK_FAIL
  echo "${FUNCNAME} ..." >> ${OK_FAIL}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]">> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
    
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(browser_load_web http=${NEW_BAIDU},png=${FUNCNAME}.png)" = "browser_load_web success" ] &&
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL}
}

###PFT-2512 Wifi status consistent show
##Init    :
##Step    : turn on/off in Wireless & Network 
##Check   : wpa_cli ping
function PFT_2512_Wifi_status_consistent_show() {
  echo " " >> $OK_FAIL
  echo "${FUNCNAME} ..." >> ${OK_FAIL}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]">> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] &&
  sleep 2s &&
  [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}
 
###PFT-2513 Manually scan available AP and connect
##Init   : Open wifi
##Step   : 1.manual scan  2.connect
##Check  : Screen capture
function PFT_2513_Manually_scan_available_AP_and_connect() {
  echo " " >> ${OK_FAIL}
  echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL} 
}

#Test Case ID PFT-2514 Show AP security status and details
function PFT_2514_Show_AP_security_status_and_details() {
  echo " " >> ${OK_FAIL}
  echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
 
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL} 
}

###Test Case ID PFT-2515 Connect to AP with static IP when have no static on DUT
function PFT_2515_Connect_to_AP_with_static_IP_when_have_no_static_on_DUT() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(disable_DHCP_and_setting_default_SSID)" = "disable_DHCP_and_setting_default_SSID fail" ] &&
  echo "${FUNCNAME} disable_DHCP_and_setting_default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return

  [ "$(add_network)" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

###Test Case ID PFT-2516 Connect to AP with static IP when have static IP on DUT
function PFT_2516_Connect_to_AP_with_static_IP_when_have_static_IP_on_DUT() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(disable_DHCP_and_setting_default_SSID)" = "disable_DHCP_and_setting_default_SSID fail" ] &&
  echo "${FUNCNAME} disable_DHCP_and_setting_default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return

  [ "$(add_network ip=${DUT_IP_ADDR})" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_load_web http=${NEW_BAIDU},png=${FUNCNAME})" = "browser_load_web success" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

### Test Case ID PFT-2517 Modify AP profile which is added before
function PFT_2517_Modify_AP_profile_which_is_added_before() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

### Test Case ID PFT-2518 Read configuration about saved AP
function PFT_2518_Read_configuration_about_saved_AP() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

### Test Case ID PFT-2519 Read detail info of connected AP profile
function PFT_2519_Read_detail_info_of_connected_AP_profile() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(add_network)" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_first_ssid ${FUNCNAME})" = "screen_captrue_first_ssid success" ] &&
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL}
}

### Test Case ID PFT-2520 Exploratory testing of Wifi UI
function PFT_2520_Exploratory_testing_of_Wifi_UI() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

###PFT-2521 Download a file ,when connect to available AP
##Init  : Be connected
##Steps : Download a mp3 file
##Check : whether the file is OK or NOT
function PFT_2521_Download_a_file_when_connect_to_available_AP() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(download_data_via_browser http=${MP3},file_name=${FUNCNAME}.mp3)" = "download_data_via_browser success" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

### Test Case ID PFT-2522 WiFi icon disappears after disconnet from AP
function PFT_2522_Wifi_icon_disappears_after_disconnect_from_AP() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(add_network)" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_ssid ${FUNCNAME}_con.png)" = "screen_captrue_ssid success" ] &&
  echo "${FUNCNAME} [CHECK1]" >> ${OK_FAIL} &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] && sleep 5s
  [ "$(screen_captrue_ssid ${FUNCNAME}_discon.png)" = "screen_captrue_ssid success" ] &&
  echo "${FUNCNAME} [CHECK2]" >> ${OK_FAIL}
}

### Test Case ID PFT-2523 Show signal strength after connect to an AP
function PFT_2523_Show_signal_strength_after_connect_to_an_AP() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

### Test Case ID PFT-2524 Show password option when input password
function PFT_2524_Show_password_option_when_input_password() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(connect_first_ssid show_password=true,png_name=${FUNCNAME})" = "connect_first_ssid success" ] && 
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL}
}

###PFT-2525 Turn on\off Wifi many times
##Init   : Many available AP
##Steps  : Open or Close wifi many time, and auto scan
##Check  : screen capture
function PFT_2525_Turn_on_off_Wifi_many_times() {
  echo " " >> ${OK_FAIL}
  echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  for i in 1 2 3 4 5 6 7 8 9 10 ;do
    [ "$(open_wifi)" = "open_wifi success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}.png)" = "adb_screencap success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    continue
    return
  done
    
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

###PFT_2526 Connect to a AP automatically
##Init    :
##Steps   :
##Check   :
function PFT_2526_Connect_to_a_AP_automatically() {
  echo " " >> ${OK_FAIL}
  echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${tag} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${tag} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(reload_wpa_supplicant_conf)" = "reload_wpa_supplicant_conf success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] &&
  sleep 15s && 
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

###PFT-2527 Test Airplane mode when wifi is enabled
##Init    : Be connected
##Steps   : Turn on and turn off Airplane mode 5 times
##Check   : Wifi disable and enable automatically  
function PFT_2527_Test_Airplane_mode_when_wifi_is_enabled() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  for i in 1 2 3 4 5 ; do
    [ "$(enable_airplane)" = "enable_airplane success" ] &&
    sleep 3s &&
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]  &&
    [ "$(disable_airplane)" = "disable_airplane success" ] &&
    sleep 15s &&
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
    continue
    return  
  done
  echo "$FUNCNAME [OK]" >> ${OK_FAIL}
}

###Test Case ID PFT-2528 Can config static IP for AP on PUT
function PFT_2528_Can_config_static_IP_for_AP_on_DUT() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "${FUNCNAME} clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "${FUNCNAME} Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return
 
  [ "$(connect_first_ssid show_advances=true)" = "connect_first_ssid success" ] && 
  echo "${FUNCNAME} [OK]" >> ${OK_FAIL}
}

## Test Case ID PFT-2529 Disconnect to a AP automatically
function PFT_2529_Disconnect_to_a_AP_automatically() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

##PFT-2530 Turn on wifi after Master Clear the device
function PFT_2530_Turn_on_wifi_after_Master_Clear_the_device() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(connect_first_ssid)" = "connect_first_ssid fail" ] && return
  [ "$(master_clear)" = "master_clear success" ] &&
  sleep 180s &&
  [ "$(open_wifi)" = "open_wifi success" ] &&
  sleep 15s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  echo "$FUNCNAME [OK]" >> ${OK_FAIL}
}

###Test Case ID PFT-2531 Test WiFi and BT function when they are enabled
function PFT_2531_Test_WiFi_and_BT_function_when_they_are_enabled() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

###Test Case ID PFT-2532 Connect to AP with proxy settings 
function PFT_2532_Connect_to_AP_with_proxy_settings() {
  echo " " >> ${OK_FAIL} && echo "${FUNCNAME} ..." >> ${OK_FAIL}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

###Test Case ID PFT-2533 Turn on/Turn off Wi-Fi
function PFT_2533_Turn_on_Turn_off_WiFi() {
  echo " " >> ${OK_FAIL} && echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && sleep 2s && return

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_open.png)" = "adb_screencap success" ] &&
  [ "$(close_wifi)" = "close_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_close.png)" = "adb_screencap success" ] &&
  
}

###Case ID PFT-2536 Manually scan available AP
function PFT_2536_manually_scan_available_ap() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] && 
  echo "$FUNCNAME [CHECK]" >> ${OK_FAIL}
}

######################################################################################
###Part 2 :    Basic function of advanced function
######################################################################################

### Test Case ID PFT-2568 Support view IP/MAC address
function PFT_2568_Support_view_IP_MAC_address() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_IP_MAC png=${FUNCNAME}_con.png)" = "screen_captrue_IP_MAC success" ] &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_IP_MAC png=${FUNCNAME}_discon.png)" = "screen_captrue_IP_MAC success" ] &&
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL}
}

### Test Case ID PFT-2572 Keep Wi-Fi on during sleep-Always
function PFT_2572_Keep_WiFi_on_during_sleep_always() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME [MANUAL]" >> ${OK_FAIL}
}

### Test Case ID PFT-2573 Keep Wi-Fi on during sleep-Only when plugged in
function PFT_2573_Keep_WiFi_on_during_sleep_only_when_plugged_in() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME [MANUAL]" >> ${OK_FAIL}
}

###Test Case ID PFT-2574 Keep Wi-Fi on during sleep-Never(increase data usage)
function PFT_2574_Keep_WiFi_on_during_sleep_never() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME [MANUAL]" >> ${OK_FAIL}
}


######################################################################################
###Part 3 :    Open Mode
######################################################################################
###Test Case ID PFT-2576 Add a AP with OPEN manually
function PFT_2576_Add_a_ap_with_open_manually() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(add_network ssid=PFT_2576,mode=${SECURT_MODE_NONE},password=${SSID_PASSWORD})" = "add_network success" ] &&
  [ "$(add_network ssid=PFT_2576,mode=${SECURT_MODE_NONE},password=${SSID_PASSWORD})" = "add_network success" ] &&
  [ "$(screen_captrue_last_ssid png=${FUNCNAME}.png)" = "screen_captrue_last_ssid success" ] &&
  echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL}
}

######################################################################################
###Part 4 :    WPA/WPA2 PSK
######################################################################################
###Test Case ID PFT-2590 Add a AP with WPA/WPA2 PSK manually+Forget AP
function PFT_2590_Add_a_ap_with_WPA_WPA2_PSK_manually_Forget_AP() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Basic_Wireless_Settings ssid_24g=PFT_2590,ssid_broadcast_24g=1)" = "Basic_Wireless_Settings fail" ] &&
  echo "$FUNCNAME Setting_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  echo "$FUNCNAME Wireless_Security [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  [ "$(add_network ssid=PFT_2590,mode=${SECURT_MODE_WPA_WPA2},password=${SSID_PASSWORD})" = "add_network success" ] &&
  sleep 15s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_first_ssid png=${FUNCNAME}_con1.png)" = "screen_captrue_first_ssid success" ] &&
  echo "$FUNCNAME [CHECK1]" >> ${OK_FAIL}

  [ "$(add_network ssid=PFT_2590,mode=${SECURT_MODE_WPA_WPA2},password=${SSID_PASSWORD})" = "add_network success" ] &&
  [ "$(screen_captrue_first_ssid png=${FUNCNAME}_con2.png)" = "screen_captrue_first_ssid success" ] &&
  [ "$(screen_captrue_last_ssid png=${FUNCNAME}_last.png)" = "screen_captrue_last_ssid success" ] &&
  echo "${FUNCNAME} [CHECK2]" >> ${OK_FAIL}

  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID success" ]  &&
  sleep 15s &&
  [ "$(screen_captrue_ssid png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid success" ] &&
  echo "${FUNCNAME} [CHECK3]" >> ${OK_FAIL}
} 

######################################################################################
###Part 5 :    WEP
######################################################################################
###Test Case ID PFT-2628 Modify AP with WEP manually
function PFT_2628_Modify_ap_with_wep_manully() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  
  [ "$(Basic_Wireless_Settings)" = "Basic_Wireless_Settings fail" ] &&
  echo "$FUNCNAME Basic_Wireless_Settings [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  [ "$(Wireless_Security security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "Wireless_Security fail" ] &&
  echo "$FUNCNAME Wireless_Security [FAIL]" >> ${OK_FAIL} && sleep 2s && return 

  [ "$(connect_first_ssid password=${SSID_PASSWORD_WEP})" = "connect_first_ssid success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_first_ssid png=${FUNCNAME}_con.png)" = "screen_captrue_first_ssid success" ] &&
  echo "$FUNCNAME [CHECK]" >> ${OK_FAIL}
}

######################################################################################
###Part 6 :    WPS
######################################################################################
###Test Case ID PFT-2718 WPS-PBC with WPA/WPA2+DHCP enabled +SSID enable
function PFT_2718_WPS_PBC_with_WPA_WPA2_DHCP_enabled_SSID_enable() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID fail" ] &&
  echo "$FUNCNAME Setting_Default_SSID [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  for i in 1 2 3 ; do 
    [ "$(enable_wps_pin)" = "enable_wps_pin success" ] && 
    [ "$(Click_WiFi_Protected_Setup_Button)" = "Click_WiFi_Protected_Setup_Button success" ] &&
    sleep 30s && cursor_click &&
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
    [ "$(download_data_via_browser http=${MP3},file_name=${FUNCNAME}.mp3)" = "download_data_via_browser success" ] &&
    echo "${FUNCNAME} [CHECK]" >> ${OK_FAIL} && return
  done
}

######################################################################################
###Part 7 :    Hotspot
######################################################################################
###Test Case ID PFT-2364 Show icon at status bar to notify user.
function PFT_2364_Show_icon_at_status_bar_to_notify_user() {
  echo " " >> ${OK_FAIL}
  echo "$FUNCNAME ..." >> ${OK_FAIL}
 
  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && 
  sleep 2s && return

  for i in 1 2 3 ; do 
    [ "$(enable_hotspot)" = "enable_hotspot success" ] &&
####.....................#######################
    echo ""
  done 
}  


######################################################################################
###Part 8 :    Wi-Fi performances 
######################################################################################
function DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_BG})" = "Basic_Wireless_Settings fail" ] &&
  echo "$FUNCNAME fail" && return
  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  echo "$FUNCNAME fail" && return

  [ "$(add_network ssid=${SSID},mode=${SECURT_MODE_WPA_WPA2},password=${SSID_PASSWORD})" = "add_network success" ] &&
  [ "$(adb_push_iperf)" = "adb_push_iperf success" ] && sleep 3s && 
  [ "$(pc_iperf_s)" = "pc_iperf_s success" ] &&
  [ "$(dut_iperf_c $FUNCNAME)" = "dut_iperf_c success" ] && 
  echo "$FUNCNAME success"
  pc_kill_9_iperf_s
}

######################################################################################
###Part 8 :    Wi-Fi performances 
######################################################################################
function DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_BG})" = "Basic_Wireless_Settings fail" ] &&
  echo "$FUNCNAME fail" && return
  [ "$(Wireless_Security)" = "Wireless_Security fail" ] &&
  echo "$FUNCNAME fail" && return

  [ "$(add_network ssid=${SSID},mode=${SECURT_MODE_WPA_WPA2},password=${SSID_PASSWORD})" = "add_network fail" ] && return
  [ "$(adb_push_iperf)" = "adb_push_iperf fail" ] && return 
  { 
    sleep 5s
    [ "$(pc_iperf_c)" = "pc_iperf_s fail" ] && return || dut_kill_9_iperf_s 
  }&

  [ "$(dut_iperf_s $FUNCNAME)" = "dut_iperf_c success" ]  
  echo "$FUNCNAME success"
}

