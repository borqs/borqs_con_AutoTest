#/bin/bash

######################################################################################
###Here are the Global Variable Parameters
######################################################################################
#export DEVICES_MASTER="45010053454d30384790061f1a2230ab"
export DEVICES_MASTER="45010053454d30384790061f1a2230ab"
export DEVICES_SLAVE=""
export SSID="wlan_autotest"
export SSID_5G="wlan_autotest_5G"
export BSSID="58:6d:8f:85:cf:56"
export SSID_PASSWORD="12345678"
export SSID_PASSWORD_WEP="1234567890"
export SECURT_MODE_WPA_WPA2="wpa2_personal"
export SECURT_MODE_WEP="wep"
export SECURT_MODE_NONE="none"
export NETWORK_MODE_BG="mixed"
export NETWORK_MODE_A=""
export NETWORK_MODE_N=""
export AP_IP_ADDR="192.168.1.1"
export PC_IP_ADDR="192.168.1.222"
export DUT_IP_ADDR="192.168.1.111"
export WEB_INDEX="http://192.168.1.222/index.html"
export WEB_DOWNLOAD_MP3="http://192.168.1.222/test/Beijing_Beijing.mp3"
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
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
    
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(browser_load_web http=${NEW_BAIDU},png=${FUNCNAME}.png)" = "browser_load_web success" ] &&
  check ${FUNCNAME} 
}

###PFT-2512 Wifi status consistent show
##Init    :
##Step    : turn on/off in Wireless & Network 
##Check   : wpa_cli ping
function PFT_2512_Wifi_status_consistent_show() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] && sleep 2s &&
  [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping success" ] &&
  check ${FUNCNAME}
}
 
###PFT-2513 Manually scan available AP and connect
##Init   : Open wifi
##Step   : 1.manual scan  2.connect
##Check  : Screen capture
function PFT_2513_Manually_scan_available_AP_and_connect() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  check ${FUNCNAME} 
}

#Test Case ID PFT-2514 Show AP security status and details
function PFT_2514_Show_AP_security_status_and_details() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

###Test Case ID PFT-2515 Connect to AP with static IP when have no static on DUT
function PFT_2515_Connect_to_AP_with_static_IP_when_have_no_static_on_DUT() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_opsi ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME},dhcp=false)" = "set_ap_ops fail" ] && return

  [ "$(add_network)" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  check ${FUNCNAME}
}

###Test Case ID PFT-2516 Connect to AP with static IP when have static IP on DUT
function PFT_2516_Connect_to_AP_with_static_IP_when_have_static_IP_on_DUT() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME},dhcp=false)" = "set_ap_ops fail" ] && return

  [ "$(add_network ip=${DUT_IP_ADDR})" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_load_web http=${NEW_BAIDU},png=${FUNCNAME}.png)" = "browser_load_web success" ] &&
  check ${FUNCNAME}
}

### Test Case ID PFT-2517 Modify AP profile which is added before
function PFT_2517_Modify_AP_profile_which_is_added_before() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2518 Read configuration about saved AP
function PFT_2518_Read_configuration_about_saved_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2519 Read detail info of connected AP profile
function PFT_2519_Read_detail_info_of_connected_AP_profile() {
  work_tag ${FUNCNAME}
  
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
 
  [ "$(add_network)" = "add_network success" ] && sleep 10s
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_first_ssid ${FUNCNAME})" = "screen_captrue_first_ssid success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2520 Exploratory testing of Wifi UI
function PFT_2520_Exploratory_testing_of_Wifi_UI() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###PFT-2521 Download a file ,when connect to available AP
##Init  : Be connected
##Steps : Download a mp3 file
##Check : whether the file is OK or NOT
function PFT_2521_Download_a_file_when_connect_to_available_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(download_data_via_browser http=${MP3},file_name=${FUNCNAME}.mp3)" = "download_data_via_browser success" ] &&
  check ${FUNCNAME}
}

### Test Case ID PFT-2522 WiFi icon disappears after disconnet from AP
function PFT_2522_Wifi_icon_disappears_after_disconnect_from_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return 

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
 
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(screen_captrue_ssid ${FUNCNAME}_con.png)" = "screen_captrue_ssid success" ] &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] && sleep 5s
  [ "$(screen_captrue_ssid ${FUNCNAME}_discon.png)" = "screen_captrue_ssid success" ]

  check ${FUNCNAME} 
}

### Test Case ID PFT-2523 Show signal strength after connect to an AP
function PFT_2523_Show_signal_strength_after_connect_to_an_AP() {
  work_tag ${FUNCNAME}
  echo "${FUNCNAME} [MANUAL]" >> ${OK_FAIL}
}

### Test Case ID PFT-2524 Show password option when input password
function PFT_2524_Show_password_option_when_input_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
 
  [ "$(connect_first_ssid show_password=true,png_name=${FUNCNAME})" = "connect_first_ssid success" ] && 
  check ${FUNCNAME} 
}

###PFT-2525 Turn on\off Wifi many times
##Init   : Many available AP
##Steps  : Open or Close wifi many time, and auto scan
##Check  : screen capture
function PFT_2525_Turn_on_off_Wifi_many_times() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  for i in 1 2 3 4 5 6 7 8 9 10 ;do
    [ "$(open_wifi)" = "open_wifi success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}.png)" = "adb_screencap success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    continue
    return
  done
    
  check ${FUNCNAME} 
}

###PFT_2526 Connect to a AP automatically
##Init    :
##Steps   :
##Check   :
function PFT_2526_Connect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(reload_wpa_supplicant_conf)" = "reload_wpa_supplicant_conf success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 15s && 
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  check ${FUNCNAME}
}

###PFT-2527 Test Airplane mode when wifi is enabled
##Init    : Be connected
##Steps   : Turn on and turn off Airplane mode 5 times
##Check   : Wifi disable and enable automatically  
function PFT_2527_Test_Airplane_mode_when_wifi_is_enabled() {
  work_tag ${FUNCNAME}

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  for i in 1 2 3 4 5 ; do
    [ "$(enable_airplane)" = "enable_airplane success" ] &&
    sleep 3s &&
    [ "$(adb_wpa_cli_ping)" = "adb_wpa_cli_ping fail" ]  &&
    [ "$(disable_airplane)" = "disable_airplane success" ] &&
    sleep 15s &&
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] && continue
    return  
  done

  check ${FUNCNAME}
}

###Test Case ID PFT-2528 Can config static IP for AP on PUT
function PFT_2528_Can_config_static_IP_for_AP_on_DUT() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
 
  [ "$(connect_first_ssid show_advances=true)" = "connect_first_ssid success" ] &&
  check ${FUNCNAME} 
}

## Test Case ID PFT-2529 Disconnect to a AP automatically
function PFT_2529_Disconnect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

##PFT-2530 Turn on wifi after Master Clear the device
function PFT_2530_Turn_on_wifi_after_Master_Clear_the_device() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid fail" ] && return
  [ "$(master_clear)" = "master_clear success" ] && sleep 180s &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 15s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  check ${FUNCNAME}
}

###Test Case ID PFT-2531 Test WiFi and BT function when they are enabled
function PFT_2531_Test_WiFi_and_BT_function_when_they_are_enabled() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2532 Connect to AP with proxy settings 
function PFT_2532_Connect_to_AP_with_proxy_settings() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2533 Turn on/Turn off Wi-Fi
function PFT_2533_Turn_on_Turn_off_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_open.png)" = "adb_screencap success" ]

  [ "$(close_wifi)" = "close_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_close.png)" = "adb_screencap success" ]

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_open_directly.png)" = "adb_screencap success" ]

  [ "$(close_wifi_directly)" = "close_wifi_directly success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_close_directly.png)" = "adb_screencap success" ]
 
  check ${FUNCNAME} 
}

###Test Case ID PFT-2534 Start to auto scan after turn on Wi-Fi
function PFT_2534_Start_to_auto_scan_after_turn_on_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] && sleep 3s
  [ "$(adb_screencap png=${FUNCNAME}_open_directly.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

###Test Case ID PFT-2535 Auto refresh scan result every period of time
function PFT_3535_Auto_refresh_scan_results_every_period_of_time() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 10s &&
  [ "$(adb_screencap png=${FUNCNAME}_before.png)" = "adb_screencap success" ] &&
  [ "$(Basic_Wireless_Settings ssid_24g=PFT_3533)" = "Basic_Wireless_Settings success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 10s &&
  [ "$(adb_screencap png=${FUNCNAME}_later.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

###Case ID PFT-2536 Manually scan available AP
function PFT_2536_manually_scan_available_ap() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] && 
  echo "$FUNCNAME [CHECK]" >> ${OK_FAIL}
}

###Test Case ID PFT-2537 Show AP signal strength,SSID,security type of scanned network from AP list after auto scan 
function PFT_2537_Show_AP_signal_strength_SSID_security_type_of_scanned_network_from_AP_list_after_auto_scan() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_default.png)" = "adb_screencap success" ] 

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_NONE})" = "set_ap_ops success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 10s &&
  [ "$(adb_screencap png=${FUNCNAME}_none.png)" = "adb_screencap success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP})" = "set_ap_ops success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 10s &&
  [ "$(adb_screencap png=${FUNCNAME}_wep.png)" = "adb_screencap success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_80211x_EAP})" = "set_ap_ops success" ] &&
  [ "$(open_wifi)" = "open_wifi success" ] && sleep 10s &&
  [ "$(adb_screencap png=${FUNCNAME}_80211eap.png)" = "adb_screencap success" ]

  check ${FUNCNAME} 
}

### Test Case ID PFT-2538 Show different security type and Signal strength for AP
function PFT_2538_Show_different_security_type_and_Signal_strength_for_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid png=${FUNCNAME}_default.png)" = "screen_captrue_ssid success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g={SECURT_MODE_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid png=${FUNCNAME}_wep.png)" ] 

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g={SECURT_MODE_80211x_EAP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid png=${FUNCNAME}_80211eap.png)" ]
 
  check ${FUNCNAME} 
}

###Test Case ID PFT-2539 Support show password option when input password
function PFT_2539_Support_show_password_option_when_input_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
  
  [ "$(connect_first_ssid show_password=true,png=${FUNCNAME}_con.png)" = "connect_first_ssid success" ]

  [ "$(add_network mode=${SECURT_MODE_WEP},password={SECURT_MODE_WEP},show_password=true,png=${FUNCNAME}_pw_wep.png)" = "add_network success" ]

  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2},password={SECURT_MODE_WEP},show_password=true,png=${FUNCNAME}_pw_wpa2.png)" = "add_network success" ] 

  [ "$(add_network mode=${SECURT_MODE_80211x_EAP},password={SECURT_MODE_WEP},show_password=true,png=${FUNCNAME}_pw_wpa2.png)" = "add_network success" ]
  
  check ${FUNCNAME} 
}

### Test Case ID PFT-2540 Connect Ap manually and show signal strength and read detail info of connecting AP
function PFT_2540_Connect_Ap_manually_and_show_signal_strength_and_read_detail_info_of_connecting_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2541 Show Wi-Fi icon for connected network and icon will disappear after turn off Wi-Fi
function PFT_2541_Show_WiFi_icon_for_connected_network_and_icon_will_disappear_after_turn_off_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
  
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && {
    {
      sleep 3s
      adb_screencap png=${FUNCNAME}_download.png
    }&
    [ "$(download_data_via_browser http=${MP3},file_name=${FUNCNAME}.mp3)" = "download_data_via_browser success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    [ "$(open_wifi)" = "open_wifi" ] && sleep 5s &&
    [ "$(adb_screencap png=${FUNCNAME}_con.png)" = "adb_wpa_cli_bssid_status success" ]
  } &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2542 Connect to at least two APs successively manually.
function PFT_2542_Connect_to_at_least_two_APs_successively_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2543 Disconnect and Connect to a AP automatically
function PFT_2543_Disconnect_and_Connect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
  
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(Disable_SSID)" = "Disable_SSID success" ] && sleep 10s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(Setting_Default_SSID)" = "Setting_Default_SSID success" ] && sleep 10s &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  check ${FUNCNAME}
}

###Test Case ID PFT-2544 Cannot connect AP successfully with wrong password
function PFT_2544_Cannot_connect_AP_successfully_with_wrong_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success"] && {
    [ "$(connect_first_ssid password=0987654321)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_wep_discon_len_10.png)" = "adb_screencap success" ]
    
    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_wep_discon_len_9.png)" = "adb_screencap success" ]
  }
  
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_WPA2})" = "set_ap_ops success"] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_wpa2_discon_len_10.png)" = "adb_screencap success" ]
    
    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_wpa2_discon_len_9.png)" = "adb_screencap success" ]
  }
  
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_80211x_EAP})" = "set_ap_ops success"] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_eap_discon_len_10.png)" = "adb_screencap success" ]
    
    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_eap_discon_len_9.png)" = "adb_screencap success" ]
  }

  check ${FUNCNAME} 
}

### Test Case ID PFT-2545 Modify network-1
function PFT_2545_Modify_network_1() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2546 Modify network-2
function PFT_2546_Modify_network_2() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2547 Forget AP
function PFT_2547_Forget_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2548 Auto connect to other AP between BSSIDs with same SSID.
function PFT_2548_Auto_connect_to_other_AP_between_BSSIDs_with_same_SSID() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2549 Support AP 'Show advanced options'
function PFT_2549_Support_AP_Show_advanced_options() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2550 Can config static IP for AP on PUT
function PFT_2550_Can_config_static_IP_for_AP_on_PUT() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2551 AP channel 1-13 
function PFT_2551_AP_channel_1_13() {
  work_tag ${FUNCNAME}
  
  [ "$(master_clear)" = "master_clear success" ] && {
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
      [ "$(set_ap_ops func=${FUNCNAME},channel_24g=$i)" = "set_ap_ops success" ] &&
      [ "$(clean_wifi_operations)" = "clean_wifi_operations success" ] &&
      [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && 
      [ "$(adb_screencap ${FUNCNAME}_${i}.png)" = "adb_screencap success" ]
    done 
  }

  check ${FUNCNAME} 
  echo "${FUNCNAME} [!!!]: Please Plug in SIM Card And Do again" >> ${OK_FAIL}
}

###Test Case ID PFT-2552 Reconnect priority test
function PFT_2552_Reconnect_priority_test() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2553 Wi-Fi throughput test
function PFT_2553_WiFi_throughput_test() {
  work_tag ${FUNCNAME}
  
  for i in 1 2 3 ;do
    DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70 
    DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70

    DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70
    DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70 

    DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70
    DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70
  done
  
  check ${FUNCNAME} 
  echo "${FUNCNAME} [!!!]: Please Keep RSSI [70, 80] And Do again" >> ${OK_FAIL}
}

### Test Case ID PFT-2554 Add a AP profile with None
function PFT_2554_Add_a_AP_profile_with_None() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_HIDE},security_mode_24g={SECURT_MODE_NONE})" = "set_ap_ops fail" ] && return
  
  [ "$(add_network mode={SECURT_MODE_NONE})" = "add_network success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2555 Add a AP profile with WEP 
function PFT_2555_Add_a_AP_profile_with_WEP() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_HIDE},security_mode_24g={SECURT_MODE_WEP})" = "set_ap_ops fail" ] && return
  
  [ "$(add_network mode={SECURT_MODE_WEP})" = "add_network success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2556 Add a AP profile with WPA2 
function PFT_2556_Add_a_AP_profile_with_WPA2() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_HIDE})" = "set_ap_ops fail" ] && return
  
  [ "$(add_network mode={SECURT_MODE_WPA_WPA2})" = "add_network success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}


### Test Case ID PFT-2557 Support add use-configured AP with None/WEP/ WPA/WPA2 PSK/802.11x EAP 
function PFT_2557_Support_add_use_configured_AP_with_None_WEP_WPA2_802.11x_EAP() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(add_network mode={SECURT_MODE_NONE}, ssid='PFT_2557_NONE')" = "add_network success" ] 
  [ "$(add_network mode={SECURT_MODE_WPA_WPA2}, ssid='PFT_2557_WPA2')" = "add_network success" ] 
  [ "$(add_network mode={SECURT_MODE_WEP}, ssid='PFT_2557_WEP')" = "add_network success" ] 
  [ "$(add_network mode={SECURT_MODE_80211x_EAP, ssid='PFT_2557_EAP')" = "add_network success" ] 
  [ "$(adb_screencap png=${FUNCNAME}.png,locate=${FUNCNAME}.png)" = "adb_screencap success" ]
 
  check ${FUNCNAME} 
}

###  Test Case ID PFT-2558 Can support edit SSID of wifi.
function PFT_2558_Can_support_edit_SSID_of_wifi() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###  Test Case ID PFT-2559 Password length test for Wi-Fi with WPA/WPA2 PSK mode
function PFT_2559_Password_length_test_for_WiFi_with_WPA2_mode() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(add_network ssid='PFT_2559_l8',mode=${SECURT_MODE_WPA_WPA2},password='Aa%#&@$',show_password=true,password_png=${FUNCNAME}_l8.png)" = "add_network success" ] && sleep 3 
  [ "$(add_network ssid='PFT_2559_8',mode=${SECURT_MODE_WPA_WPA2},password='AaB%#&@$',show_password=true,password_png=${FUNCNAME}_8.png)" = "add_network success" ] && sleep 3 
  [ "$(add_network ssid='PFT_2559_m8',mode=${SECURT_MODE_WPA_WPA2},password='AaBBB%#&@$',show_password=true,password_png=${FUNCNAME}_m8)" = "add_network success" ] && sleep 3 
  
  [ "$(add_network ssid='PFT_2559_mm8',mode=${SECURT_MODE_WPA_WPA2},password='abcdefghijklmnopqrstuvwxyz',show_password=true,password_png=${FUNCNAME}_mm8.png)" = "add_network success" ] && sleep 3 
 
  [ "$(adb_screencap png=${FUNCNAME}.png,locate='tail')" = "adb_screencap success" ] && 
  check ${FUNCNAME} 
} 

###  Test Case ID PFT-2559 Password length test for Wi-Fi with WEP mode
function PFT_2560_Password_length_test_for_WiFi_with_WEP_mode() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(add_network ssid='PFT_2560_l16',mode=${SECURT_MODE_WEP},password='Aa%#&@$',show_password=true,password_png=${FUNCNAME}_l16.png)" = "add_network success" ] && sleep 3
  [ "$(add_network ssid='PFT_2560_16',mode=${SECURT_MODE_WEP},password='AaBbCcDdEeF%#&@$',show_password=true,password_png=${FUNCNAME}_16.png)" = "add_network success" ] && sleep 3
  [ "$(add_network ssid='PFT_2560_m16',mode=${SECURT_MODE_WEP},password='AaBBBCcDdEeFfGg%#&@$',show_password=true,password_png=${FUNCNAME}_m16)" = "add_network success" ] && sleep 3

  [ "$(add_network ssid='PFT_2560_mm16',mode=${SECURT_MODE_WEP},password='abcdefghijklmnopqrstuvwxyz',show_password=true,password_png=${FUNCNAME}_mm16.png)" = "add_network success" ] && sleep 3

  [ "$(adb_screencap png=${FUNCNAME}.png,locate='tail')" = "adb_screencap success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2563 Wifi frequency band 
function PFT_2563_WiFi_frequency_band() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(screen_captrue_advances freq_band='true',png=${FUNCNAME}.png)" = "screen_captrue_advances success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2564 Default by wifi frequency band  
function PFT_2564_Default_by_wifi_frequency_band () {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(screen_captrue_advances freq_band='true',png=${FUNCNAME}.png)" = "screen_captrue_advances success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2566 2.4GHz only with wifi frequency band
function PFT_2556_24G_only_with_wifi_frequency_band() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid locate='head',png=${FUNCNAME}_default.png)" = "screen_captrue_ssid success" ] &&
  [ "$(screen_captrue_advances set_freq_band='24g',png=${FUNCNAME}_set_24g.png)" = "screen_captrue_advances success" ] &&
  [ "$(screen_captrue_ssid locate='head',png=${FUNCNAME}_24g.png)" = "screen_captrue_ssid success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2567 Never break wifi connection if cable is plugged in
function PFT_2567_Never_break_wifi_connection_if_cable_is_plugged_in() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2568 Support view IP/MAC address
function PFT_2568_Support_view_IP_MAC_address() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
 
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_advances ip_mac=true)" = "screen_captrue_advances success" ] &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_advances ip_mac=true)" = "screen_captrue_advances success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2569 Turn on/Turn off open network notification
function PFT_2569_Turn_on_Turn_off_open_network_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2570 Open network notification 
function PFT_2570_Open_network_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2571 Should enter into wifi setting screen when tapping 'Wi-Fi networks available' from notifica
function Should_enter_into_wifi_setting_screen_when_tapping_WiFi_networks_available_from_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2572 Keep Wi-Fi on during sleep-Always
function PFT_2572_Keep_Wi_Fi_on_during_sleep_Always() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2573 Keep Wi-Fi on during sleep-Only when plugged in
function PFT_2573_Keep_WiFi_on_during_sleep_Only_when_plugged_in() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2574 Keep Wi-Fi on during sleep-Never(increase data usage)
function PFT_2574_Keep_WiFi_on_during_sleep_Never_increase_data_usage() { 
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2575 Periodic scan test
function PFT_2575_Periodic_scan_test() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

###Test Case ID PFT-2576 Add a AP with OPEN manually
function PFT_2576_Add_a_ap_with_open_manually() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(add_network ssid=PFT_2576,mode=${SECURT_MODE_NONE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid locate='tail',png=${FUNCNAME}_tail.png)" = "screen_captrue_ssid success" ] &&
  [ "$(screen_captrue_ssid locate='last',png=${FUNCNAME}_last.png)" = "screen_captrue_ssid success" ] &&
  check ${FUNCNAME} 
}

### Test Case ID PFT-2577 Connect a open AP from scan result
function PFT_2577_Connect_a_open_AP_from_scan_result() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_NONE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid mode=${SECURT_MODE_NONE})" = "connect_first_ssid success" ] &&
  [ "$(browser_load_web http=${WEB_INDEX},png=${FUNCNAME}.png)" ] &&
  check ${FUNCNAME} 
}

###Test Case ID PFT-2578 Connect to a hidden AP with OPEN
function PFT_2578_Connect_to_a_hidden_AP_with_OPEN() {
  work_tag ${FUNCNAME}
 
  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return
  
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE},ssid_broadcast_24g=false)" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid locate='head',png=${FUNCNAME}_before.png)" = "screen_captrue_ssid success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_NONE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid locate='head',png=${FUNCNAME}_later.png)" = "screen_captrue_ssid" ] &&
  check ${FUNCNAME} 
}

###Test Case ID PFT-2579 Modify AP with static IP + OPEN manually
function PFT_2579_Modify_AP_with_static_IP_OPEN_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2580 Modify AP with static IP+ proxy settings + OPEN manually
function PFT_2580_Modify_AP_with_static_IP_proxy_settings_OPEN_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2581 Modify AP with proxy settings + OPEN manually
function PFT_2581_Modify_AP_with_proxy_settings_OPEN _manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2582 Add a AP with OPEN manually+Forget AP
function PFT_2582_Add_a_AP_with_OPEN_manually_Forget_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

### Test Case ID PFT-2583 Ap with OPEN+Disable DHCP+Hide SSID+Manual add+Donot have static IP+Forget AP
function PFT_2583_Ap_with_OPEN_Disable_DHCP_Hide_SSID_Manual_add_Donot_have_static_IP_Forget_AP() {
  work_tag ${FUNCNAME}

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
  check ${FUNCNAME} 
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
    check ${FUNCNAME} && return
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

function DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_A})" = "Basic_Wireless_Settings fail" ] &&
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

function DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_A})" = "Basic_Wireless_Settings fail" ] &&
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

function DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_N})" = "Basic_Wireless_Settings fail" ] &&
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

function DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70() {
  echo " " >> ${DATA_THROUGHPUT}
  echo "$FUNCNAME ..." >> ${DATA_THROUGHPUT}

  [ "$(clean_wifi_operations)" = "clean_wifi_operations fail" ] &&
  echo "$FUNCNAME clean_wifi_operations [FAIL]" >> ${OK_FAIL} && sleep 2s && return
  pc_kill_9_iperf_s
  dut_kill_9_iperf_s
 
  [ "$(Basic_Wireless_Settings network_mode_24g=${NETWORK_MODE_N})" = "Basic_Wireless_Settings fail" ] &&
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

#add_network ssid=chengkai,mode=${SECURT_MODE_WPA_WPA2},password=777777777,show_password=true,password_png=b734.png,show_advances=true,enable_advances=true,advances_png=b734_2.png,ip_address=192.168.1.33



