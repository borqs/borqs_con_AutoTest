#/bin/bash

######################################################################################
###Here are the Global Variable Parameters
######################################################################################
#You may modify these value for different PUT
#-------------------------------------------------------------------------------------
#1. You should replace these files(in prepared direction) to adapt your productions
#2. Keep your PC ip address as ${PC_IP_ADDR}
#3. 3. Set Default browser, Maybe there are more than one browsers to choose from. You can "adb shell am start -a android.intent.action.VIEW -d  http://www.baidu.com" and pick up one as default
#4. Modify below value
export DEVICES_MASTER="CLVAFFABFE7"
export DEVICES_SLAVE=""
export WIRELESS_NETWORK_WIFI_X_Y="150 150"
export WPS_PIN_X_Y="600 50"
export ADD_NETWORK_X_Y="700 50"
export PUT_TYPE="table"
##For Nebual {
  #export PUT_TYPE="phone"
  #export WIRELESS_NETWORK_WIFI_X_Y="300 190"
  #export ADD_NETWORK_X_Y="435 765"
#}
export PC_IPERF="$(pwd)/prepared/bin/iperf_x86"
export PC_CURL="$(pwd)/prepared/bin/curl_x86"
##For AP
#--------------------------------------------------------------------------------------
export NETWORK_MODE_DISABLE="disabled"
export NETWORK_MODE_A="a-only"
export NETWORK_MODE_MIXED="mixed"
export NETWORK_MODE_B="b-only"
export NETWORK_MODE_G="g-only"
export NETWORK_MODE_BG="bg-mixed"
export NETWORK_MODE_N="n-only"
export SSID="wlan_autotest"
export SSID_5G="wlan_autotest_5G"
export NETWORK_CHANNEL_WIDTH_AUTO="0"
export NETWORK_CHANNEL_WIDTH_20="20"
export NETWORK_CHANNEL_AUTO="0"
export NETWORK_CHANNEL_1="1"
export NETWORK_CHANNEL_6="6"
export NETWORK_CHANNEL_11="11"
export SSID_BROADCAST_ENABLE="0"
export SSID_BROADCAST_DISENABLE="1"
#--------------------------------------------------------------------------------------
export BSSID="58:6d:8f:85:cf:56"
export SECURT_MODE_WPA_WPA2="wpa_wpa2"
export SECURT_MODE_WPA_PERSONAL="wpa_personal"
export SECURT_MODE_WPA2_PERSONAL="wpa2_personal"
export SECURT_MODE_ENTERPRISE_MIXED_MODE="enterprise_mixed"
export SECURT_MODE_WPA_ENTERPRISE="wpa_enterprise"
export SECURT_MODE_WPA2_ENTERPRISE="wpa2_enterprise"
export SECURT_MODE_WEP="wep"
export SECURT_MODE_RADIUS="radius"
export SECURT_MODE_DISABLE="disabled"
export CRYPT_24G_MIXED="tkip%2Baes"
export CRYPT_24G_TKIP="tkip"
export CRYPT_24G_AES="aes"
export CRYPT_5G_MIXED="tkip%2Baes"
export CRYPT_5G_TKIP="tkip"
export CRYPT_5G_AES="aes"
export SSID_PASSWORD="12345678"
export SSID_PASSWORD_WEP="1234567890"
export SSID_PASSWORD_WEP_128="12345678901234567890123456"

##Below only for 802.1x option
#--------------------------------------------------------------------------------------
export PEAP="1"
export TLS="2"
export TTLS="3"
export NONE="0"
export PAP="1"
export MSCHAP="2"
export MSCHAPV2="3"
export GTC="4"
export IDENTITY="test"
export EAP_USER_PASSWORD="test"
export EAP_USER_PASSWORD_WRONG="test0"

#--------------------------------------------------------------------------------------
export DHCP_SERVER_DISABLE="static"
export DHCP_SERVER_ENABLE="dhcp"

export AP_IP_ADDR="192.168.1.1"
export PC_IP_ADDR="192.168.1.222"
export PUT_IP_ADDR="192.168.1.111"
export WEB_INDEX="http://192.168.1.222/index.html"
export WEB_DOWNLOAD_MP3="http://192.168.1.222/test/Beijing_Beijing.mp3"
export WEB_DOWNLOAD_T2="http://192.168.1.222/test/T2.tar.gz"
export PUT_DOWNLOAD_DIR="/data"
export PC_DOWNLOAD_DIR="$(pwd)/results/download"
export PNG="$(pwd)/results/png"
export PC_WPA_SUPPLICANT_CONF="$(pwd)/prepared/wpa_supplicant.conf"
export PUT_WPA_SUPPLICANT_CONF="/data/misc/wifi/wpa_supplicant.conf"
export PUT_CURL="/system/bin/curl"
export PUT_IPERF="/system/bin/iperf"
export OK_FAIL="$(pwd)/results/OK_FAIL.txt"
export DATA_THROUGHPUT="$(pwd)/results/RT.txt"
export CASE_INFO="$(pwd)/results/cases_info"
export PC_LOG="$(pwd)/results/*log.txt*"
export PC_RT="$(pwd)/results/*RT.txt*"
export STDOUT_LOG="$(pwd)/results/log_stdout.txt"
export PUT_LOG="/logs"
export RET_CHECK=11
export RET_MANUAL=12
export RET_OK=13
export RET_FAIL=14

######################################################################################
###PUT_operations.sh   :     do operations in DUT part
###router_settings.sh  :     do settings in AP part
###verifications.sh    :     check results (screen capture, wpa_cli)
###logs_about.sh       :     do about logs
######################################################################################
source $(pwd)/cases/PUT_operations.sh
source $(pwd)/cases/router_settings.sh
source $(pwd)/cases/verifications.sh
source $(pwd)/cases/logs_about.sh

######################################################################################
###Here are the cases, which could be set enable or disable in config.txt file
######################################################################################

function PFT_2511_Browser_internet_via_connect_wifi() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2.png)" = "browser_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2512_Wifi_status_consistent_show() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_open.png)" = "adb_screencap success" ] &&
  [ "$(close_wifi_directly)" = "close_wifi_directly success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_2_close.png)" = "adb_screencap success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2513_Manually_scan_available_AP_and_connect() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_scan.png)" = "adb_screencap success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2514_Show_AP_security_status_and_details() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_detail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2515_Connect_to_AP_with_static_IP_when_have_no_static_on_DUT() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_obtIPing.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2516_Connect_to_AP_with_static_IP_when_have_static_IP_on_DUT() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2517_Modify_AP_profile_which_is_added_before() {
  return ${RET_MANUAL}
}

function PFT_2518_Read_configuration_about_saved_AP() {
  return ${RET_MANUAL}
}

function PFT_2519_Read_detail_info_of_connected_AP_profile() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2520_Exploratory_testing_of_Wifi_UI() {
  return ${RET_MANUAL}
}

function PFT_2521_Download_a_file_when_connect_to_available_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_DOWNLOAD_MP3},name=${FUNCNAME}.mp3)" = "browser_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2522_Wifi_icon_disappears_after_disconnect_from_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_2_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2523_Show_signal_strength_after_connect_to_an_AP() {
  return ${RET_MANUAL}
}

function PFT_2524_Show_password_option_when_input_password() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid show_password=true,show_password_png=${FUNCNAME}_1.png)" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2525_Turn_on_off_Wifi_many_times() {
  local times_suss=0
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  for i in 1 2 3 4 5 6 7 8 9 10 ;do
    [ "$(open_wifi)" = "open_wifi success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}_open.png)" = "adb_screencap success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}_close.png)" = "adb_screencap success" ] &&
    times_suss=`expr ${times_suss} + 1 `
  done

  [ "${times_suss}" = "10" ] && return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2526_Connect_to_a_AP_automatically() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network)" = "add_network success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_add.png)" = "adb_screencap success" ] &&
  [ "$(reopen_wifi)" = "reopen_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_2_reopen.png)" = "adb_screencap success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2527_Test_Airplane_mode_when_wifi_is_enabled() {
  local try="0"
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  for i in 1 2 3 4 5 ; do
    [ "$(airplane_ops true)" = "airplane_ops success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}_discon.png)" = "adb_screencap success" ] &&

    [ "$(airplane_ops false)" = "airplane_ops success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_${i}_con.png)" = "adb_screencap success" ] &&
    try="${i}"
  done
  [ "$(airplane_ops false)" = "airplane_ops success" ]

  [ "${try}" = "5" ] && return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2528_Can_config_static_IP_for_AP_on_DUT() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2529_Disconnect_to_a_AP_automatically() {
  return ${RET_MANUAL}
}

function PFT_2530_Turn_on_wifi_after_Master_Clear_the_device() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(master_clear)" = "master_clear success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2531_Test_WiFi_and_BT_function_when_they_are_enabled() {
  return ${RET_MANUAL}
}

function PFT_2532_Connect_to_AP_with_proxy_settings() {
  return ${RET_MANUAL}
}

function PFT_2533_Turn_on_Turn_off_WiFi() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_open_directly.png)" = "adb_screencap success" ] &&

  [ "$(close_wifi_directly)" = "close_wifi_directly success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_2_close_directly.png)" = "adb_screencap success" ] &&

  [ "$(open_wifi)" = "open_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_3_open.png)" = "adb_screencap success" ] &&

  [ "$(close_wifi)" = "close_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_4_close.png)" = "adb_screencap success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2534_Start_to_auto_scan_after_turn_on_WiFi() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2535_Auto_refresh_scan_results_every_period_of_time() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_before.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops ssid_24g='PFT_2535')" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_2_later.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2536_manually_scan_available_ap() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2537_Show_AP_signal_strength_SSID_security_type_of_scanned_network_from_AP_list_after_auto_scan() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_default.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_2_none.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_3_wep.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate-'first',png=${FUNCNAME}_4_eap.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2538_Show_different_security_type_and_Signal_strength_for_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_default.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_wep.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_3_80211eap.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2539_Support_show_password_option_when_input_password() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}
  [ "$(connect_first_ssid show_password=true,show_password_png=${FUNCNAME}_1_con.png)" = "connect_first_ssid success" ] &&

  [ "$(add_network mode=${SECURT_MODE_WEP},password=${SSID_PASSWORD_WEP},show_password=true,show_password_png=${FUNCNAME}_2_pw_wep.png)" = "add_network success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2},show_password=true,show_password_png=${FUNCNAME}_3_pw_wpa2.png)" = "add_network success" ] &&
  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},show_password=true,show_password_png=${FUNCNAME}_4_pw_eap.png)" = "add_network success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2540_Connect_Ap_manually_and_show_signal_strength_and_read_detail_info_of_connecting_AP() {
  return ${RET_MANUAL}
}

function PFT_2541_Show_WiFi_icon_for_connected_network_and_icon_will_disappear_after_turn_off_WiFi() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  {
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ]
    {
      sleep 3s
      adb_screencap png=${FUNCNAME}_2_downloading.png
    }&
    [ "$(browser_ops http=${WEB_DOWNLOAD_T2},file_name=${FUNCNAME}.mp3,png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    [ "$(adb_screencap png=${FUNCNAME}_4_close.png)" = "adb_screencap success" ] &&
    [ "$(open_wifi)" = "open_wifi" ] && [ "$(adb_screencap png=${FUNCNAME}_5_open.png)" = "adb_screencap success" ]
  }
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2542_Connect_to_at_least_two_APs_successively_manually() {
  return ${RET_MANUAL}
}

function PFT_2543_Disconnect_and_Connect_to_a_AP_automatically() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_con1.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_2_discon1.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_3_discon2.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_4_con2.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2544_Cannot_connect_AP_successfully_with_wrong_password() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=0987654321)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_wep_discon_len_10.png)" = "screen_captrue_ssid_ops success" ] &&

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_2_wep_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_WPA2})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_3_wpa2_discon_len_10.png)" = "screen_captrue_ssid_ops success" ] &&

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_4_wpa2_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_5_eap_discon_len_10.png)" = "screen_captrue_ssid_ops success" ] &&

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_6_eap_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2546_Modify_network_2() {
  return ${RET_MANUAL}
}

function PFT_2547_Forget_AP() {
  return ${RET_MANUAL}
}

function PFT_2548_Auto_connect_to_other_AP_between_BSSIDs_with_same_SSID() {
  return ${RET_MANUAL}
}

function PFT_2549_Support_AP_Show_advanced_options() {
  return ${RET_MANUAL}
}

function PFT_2550_Can_config_static_IP_for_AP_on_PUT() {
  return ${RET_MANUAL}
}

function PFT_2551_AP_channel_1_13() {
  [ "$(master_clear)" = "master_clear success" ] && {
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
      [ "$(set_ap_ops func=${FUNCNAME},channel_24g=${i})" = "set_ap_ops success" ] &&
      [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
      [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
      [ "$(screen_captrue_ssid_ops ${FUNCNAME}_${i}.png)" = "screen_captrue_ssid_ops success" ]
    done
  }

  echo "${FUNCNAME} [!!!]: Please Plug in SIM Card And Do again" >> ${OK_FAIL}
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2552_Reconnect_priority_test() {
  return ${RET_MANUAL}
}

function PFT_2553_WiFi_throughput_test() {
  for i in 1 2 3 ;do
    DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70 png=${FUNCNAME}_${i}_bg_50_70_up.png
    DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70 png=${FUNCNAME}_${i}_bg_50_70_down.png

    DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70 png=${FUNCNAME}_${i}_a_50_70_up.png
    DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70 png=${FUNCNAME}_${i}_a_50_70_down.png

    DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70 png=${FUNCNAME}_${i}_n_50_70_up.png
    DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70 png=${FUNCNAME}_${i}_n_50_70_down.png
  done

  echo "${FUNCNAME} [!!!]: Please Keep RSSI [70, 80] And Do again" >> ${OK_FAIL}
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2554_Add_a_AP_profile_with_None() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate="first",png=${FUNCNAME}_1.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2555_Add_a_AP_profile_with_WEP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate="first",png=${FUNCNAME}_1.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2556_Add_a_AP_profile_with_WPA2() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate="first",png=${FUNCNAME}_1.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2557_Support_add_use_configured_AP_with_None_WEP_WPA2_802_11x_EAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE},ssid='PFT_2557_NONE')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_1_none.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2},ssid='PFT_2557_WPA_WPA2')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_2_wpa_wpa2.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WEP},ssid='PFT_2557_WEP',password=${SSID_PASSWORD_WEP})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_3_wep.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},ssid='PFT_2557_EAP')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_4_eap.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2558_Can_support_edit_SSID_of_wifi() {
  return ${RET_MANUAL}
}

function PFT_2559_Password_length_test_for_WiFi_with_WPA2_mode() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_l8',mode=${SECURT_MODE_WPA_WPA2},password="Aa%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_1_l8_pw.png)" = "add_network success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_8',mode=${SECURT_MODE_WPA_WPA2},password="AaB%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_2_8_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_3_8.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_m8',mode=${SECURT_MODE_WPA_WPA2},password="AaBBB%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_4_m8_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_5_m8.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_mm8',mode=${SECURT_MODE_WPA_WPA2},password='abcdefghijklmnopqrstuvwxyz',show_password=true,show_password_png=${FUNCNAME}_6_mm8_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_7_mm8.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2560_Password_length_test_for_WiFi_with_WEP_mode() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_l16',mode=${SECURT_MODE_WEP},password="1234Aa%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_1_l16_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_2_l16.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_16',mode=${SECURT_MODE_WEP},password="AaBbCcDdEeF%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_3_16_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_4_16.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_m16',mode=${SECURT_MODE_WEP},password="AaBBBCcDdEeFfGg%#@'&'$",show_password=true,show_password_png=${FUNCNAME}_5_m16_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_6_m16.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_mm16',mode=${SECURT_MODE_WEP},password='abcdefghijklmnopqrstuvwxyz',show_password=true,show_password_png=${FUNCNAME}_7_mm16_pw.png)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_8_mm16.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2563_WiFi_frequency_band() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}_1.png)" = "wifi_advances_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2564_Default_by_wifi_frequency_band() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}_1.png)" = "wifi_advances_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2566_24G_only_with_wifi_frequency_band() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_default.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(wifi_advances_ops enable_freq_band=true,set_freq_band='24g')" = "wifi_advances_ops success" ] &&
  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}_2_24g.png)" = "wifi_advances_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_24g.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2567_Never_break_wifi_connection_if_cable_is_plugged_in() {
  return ${RET_MANUAL}
}

function PFT_2568_Support_view_IP_MAC_address() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(wifi_advances_ops show_ip_mac=true,png=${FUNCNAME}_1_ip_mac.png)" = "wifi_advances_ops success" ] &&
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(wifi_advances_ops show_ip_mac=true,png=${FUNCNAME}_2_no_ip_mac.png)" = "wifi_advances_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2569_Turn_on_Turn_off_open_network_notification() {
  return ${RET_MANUAL}
}

function PFT_2570_Open_network_notification() {
  return ${RET_MANUAL}
}

function PFT_2571_Should_enter_into_wifi_setting_screen_when_tapping_WiFi_networks_available_from_notification() {
  return ${RET_MANUAL}
}

function PFT_2572_Keep_Wi_Fi_on_during_sleep_Always() {
  return ${RET_MANUAL}
}

function PFT_2573_Keep_WiFi_on_during_sleep_Only_when_plugged_in() {
  return ${RET_MANUAL}
}

function PFT_2574_Keep_WiFi_on_during_sleep_Never_increase_data_usage() {
  return ${RET_MANUAL}
}

function PFT_2575_Periodic_scan_test() {
  return ${RET_MANUAL}
}

function PFT_2576_Add_a_ap_with_open_manually() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network ssid='PFT_2576',mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_1_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_2_last.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2577_Connect_a_open_AP_from_scan_result() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2578_Connect_to_a_hidden_AP_with_OPEN() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_before.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_later.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2579_Modify_AP_with_static_IP_OPEN_manually() {
  return ${RET_MANUAL}
}

function PFT_2580_Modify_AP_with_static_IP_proxy_settings_OPEN_manually() {
  return ${RET_MANUAL}
}

function PFT_2581_Modify_AP_with_proxy_settings_OPEN_manually() {
  return ${RET_MANUAL}
}

function PFT_2582_Add_a_AP_with_OPEN_manually_Forget_AP() {
  return ${RET_MANUAL}
}

function PFT_2583_Ap_with_OPEN_Disable_DHCP_Hide_SSID_Manual_add_Donot_have_static_IP_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_abt_ip.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2584_Ap_with_OPEN_Disable_DHCP_Hide_SSID_Manual_add_have_static_IP_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE},enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_6_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2585_Ap_with_Open_Disable_DHCP_Show_SSID_have_static_IP_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_DISABLE},enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2586_AP_with_Open_Disable_DHCP_Show_SSID_Donot_have_static_IP_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_abt_ip.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2587_Ap_with_OPEN_Enable_DHCP_Hide_SSID_Manual_add_Donot_have_static_IP_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_6_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2588_AP_with_Open_Enable_DHCP_Show_SSID_Donot_have_static_IP_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2589_Connect_AP_with_802_11_b_and_802_11_g_and_802_11_n() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_B})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_B_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_G})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_G_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_3_N_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_6_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2590_Add_a_AP_with_WPA_WPA2_PSK_manually_Forget_AP() {
  return ${RET_MANUAL}
}

function PFT_2591_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP()
{
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2592_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2593_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2594_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2595_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2596_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password='87654321')" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_discon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2597_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2598_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2599_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2600_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2601_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2602_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2603_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2604_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2605_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2606_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2607_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321')" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2608_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2609_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2610_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2611_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2612_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2613_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321',enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2614_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_discon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2615_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2616_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png,lan_proto=${DHCP_SERVER_DISABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2617_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2618_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2619_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png,lan_proto=${DHCP_SERVER_DISABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2620_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321',enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function  PFT_2621_Ap_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_WPA_PSK_TKIP_WPA_PSK_AES_WPA2_PSK_TKIP_WPA2_PSK_AES_Security_Auto_select_encryption_Auto_select_Manual_add_Donot_have_static_IP_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2622_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2623_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png,lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2624_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2625_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
#  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2626_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_6_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2627_Connect_AP_with_802_11_b_802_11_g_802_11_n() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_WPA2},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_B})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_b_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_WPA2},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_G})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_g_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2_PERSONAL},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_n_con.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2631_AP_with_WEP_ASCII_open_authentication_Enable_DHCP_Show_SSID_64_bit_Donot_have_static_IP_Correct_pasWEP_ASCII_Enable_DHCP_Show_SSID_bit_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password=${SSID_PASSWORD_WEP})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2632_AP_with_WEP_ASCII_open_authentication_Enable_DHCP_Show_SSID_128_bit_Donot_have_static_IP_Correct_pasWEP_ASCII_Enable_DHCP_Show_SSID_bit_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP_128},encypt_wep='128')" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password=${SSID_PASSWORD_WEP_128})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP_128},encypt_wep='128')" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_4_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_5_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_7_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2633_Ap_with_WEP_ASCII_open_authentication_Disable_DHCP_Hide_SSID_64bit_Manual_add_have_static_IP_correct_password_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WEP},enable_advances=true,password=${SSID_PASSWORD_WEP})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2634_Ap_with_WEP_ASCII_open_authentication_Disable_DHCP_Hide_SSID_128bit_Manual_add_have_static_IP_correct_password_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP_128})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_1_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WEP},enable_advances=true,password=${SSID_PASSWORD_WEP_128})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_2_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_3_web.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP_128})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_5_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_6_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_7_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_8_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2636_Ap_with_WEP_ASCII_open_authentication_mode_Disable_DHCP_Show_SSID_64bit_128bit_have_static_IP_incorrect_password_forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WEP},enable_advances=true,password="12345678901234567890654321")" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_1_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2667_Configuration_Mixed_Enterprise_Mode_Environment() {
  return ${RET_MANUAL}
}

function PFT_2668_Add_AP_Mixed_Enterprise_Manually_Forget_AP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2669_Edhcp_Sssid_WPA_TKIP_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2670_Edhcp_Sssid_WPA_AES_NoStatic_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2671_Edhcp_Sssid_WPA2_TKIP_NoStatic_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2672_Edhcp_Sssid_WPA2_AES_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA2_ENTERPRISE})" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_2_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_3_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_4_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2673_Edhcp_Sssid_WPA_WPA2_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2674_Edhcp_Sssid_WPA_WPA2_TKIP_AES_NoStatic_WrongPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},eap_user_password=${EAP_USER_PASSWORD_WRONG})" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_wrong_password_head.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2675_Edhcp_Sssid_WPA_TKIP_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},enable_advances=true)" = "connect_first_ssid success" ]
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2676_Edhcp_Sssid_WPA_AES_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}


function PFT_2677_Edhcp_Sssid_WPA2_TKIP_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2678_Edhcp_Sssid_WPA2_AES_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA2_ENTERPRISE},enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2679_Edhcp_Sssid_WPA_WPA2_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},enable_advances=true)" = "connect_first_ssid fail" ] && return ${RET_FAIL}
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2680_Edhcp_Hssid_WPA_TKIP_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(open_wifi)" = "open_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_verify_HSSID.png)" = "adb_screencap success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WPA_ENTERPRISE})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2681_Edhcp_Hssid_WPA_AES_NoStatic_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2682_Edhcp_Hssid_WPA2_TKIP_NoStatic_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2683_Edhcp_Hssid_WPA2_AES_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(open_wifi)" = "open_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_verify_HSSID_1.png)" = "adb_screencap success" ] &&

  [ "$(add_network mode=${SECURT_MODE_WPA2_ENTERPRISE})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2684_Edhcp_Hssid_WPA_WPA2_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(open_wifi)" = "open_wifi success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_verify_HSSID_1.png)" = "adb_screencap success" ] &&

  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_2.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_4_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_5_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2685_Edhcp_Hssid_WPA_WPA2_TKIP_AES_NoStatic_WrongPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},eap_user_password=${EAP_USER_PASSWORD_WRONG})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_wrong_password_head.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2686_Ddhcp_Sssid_WPA_WPA2_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_noStaticIP_head.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2687_Ddhcp_Sssid_WPA_TKIP_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2688_Ddhcp_Sssid_WPA_AES_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2689_Ddhcp_Sssid_WPA2_TKIP_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2690_Ddhcp_Sssid_WPA2_AES_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA2_ENTERPRISE},enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2691_Ddhcp_Sssid_WPA_WPA2_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2692_Ddhcp_Sssid_WPA_WPA2_TKIP_AES_Static_WrongPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},enable_advances=true,eap_user_password=${EAP_USER_PASSWORD_WRONG})" = "connect_first_ssid fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_wrong_password_head.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2693_Ddhcp_Hssid_WPA_WPA2_TKIP_AES_NoStatic_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status fail" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_1_noStaticIP_head.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}


function PFT_2694_Ddhcp_Hssid_WPA_TKIP_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},security_mode_24g=${SECURT_MODE_WPA_ENTERPRISE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_WPA_ENTERPRISE},enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2695_Ddhcp_Hssid_WPA_AES_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2696_Ddhcp_Hssid_WPA2_TKIP_Static_CorrectPWD_ForgetAP() {
  return ${RET_MANUAL}
}

function PFT_2697_Ddhcp_Hssid_WPA2_AES_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_WPA2_ENTERPRISE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_WPA2_ENTERPRISE},enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2698_Ddhcp_Hssid_WPA_WPA2_Static_CorrectPWD_ForgetAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE},crypto_24g=${CRYPT_24G_MIXED})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},enable_advances=true)" = "add_network success" ] &&
  [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_1.png)" = "browser_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_2_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_3_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_4_dis_tail.png)" = "screen_captrue_ssid_ops success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2699_Connect_AP_with_b_g_n_bg_bgn() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_B})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_G})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_N},security_mode_24g=${SECURT_MODE_WPA2_PERSONAL})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_BG})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(set_ap_ops func=${FUNCNAME},network_mode_24g=${NETWORK_MODE_MIXED})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE})" = "connect_first_ssid success" ] &&

  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2700_Connect_AP_with_TTLS_PAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TTLS},phase2=${PAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2701_Connect_AP_with_TLS_GTC() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TLS},phase2=${GTC})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2702_Connect_AP_with_PEAP_PAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${PEAP},phase2=${PAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2703_Connect_AP_with_TLS_MSCHAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TLS},phase2=${MSCHAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2704_Connect_AP_with_PEAP_GTC() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${PEAP},phase2=${GTC})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2705_Connect_AP_with_PEAP_MSCHAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${PEAP},phase2=${MSCHAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2706_Connect_AP_with_PEAP_MSCHAPV2() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${PEAP},phase2=${MSCHAPV2})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2707_Connect_AP_with_TLS_PAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TLS},phase2=${PAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2708_Connect_AP_with_TLS_MSCHAPV2() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TLS},phase2=${MSCHAPV2})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2709_Connect_AP_with_TTLS_MSCHAP() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TTLS},phase2=${MSCHAP})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2711_Connect_AP_with_TTLS_GTC() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TTLS},phase2=${GTC})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2712_Connect_AP_with_TTLS_MSCHAPV2() {
  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return ${RET_FAIL}
  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops fail" ] && return ${RET_FAIL}

  [ "$(connect_first_ssid mode=${SECURT_MODE_WPA_ENTERPRISE},method=${TTLS},phase2=${MSCHAPV2})" = "connect_first_ssid success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2718_WPS_PBC_with_WPA_WPA2_DHCP_enabled_SSID_enable() {

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  for i in 1 2 3 ; do
    [ "$(wps_ops wps_pbc=true)" = "wps_ops success" ] &&
    [ "$(set_ap_ops wps_enable=true,wps_button_tap=true)" = "set_ap_ops success" ] &&
    sleep 30s && cursor_click &&
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
    [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_${i}_con.png)" = "screen_captrue_ssid_ops success" ] &&
    [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_${i}_web.png)" = "browser_ops success" ] &&
    return ${RET_CHECK} || return ${RET_FAIL} && return ${RET_FAIL}
  done
}

function PFT_2719_WPS_PIN_Entry_with_WPA_WPA2_DHCP_enabled_SSID_broadcasted() {
  return ${RET_MANUAL}
}

function PFT_2720_WPS-PIN_timeout() {
  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_before.png)" = "adb_screencap success" ] && sleep 150s &&
  [ "$(adb_screencap png=${FUNCNAME}_2_later.png)" = "adb_screencap success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2721_WPS-PBC_timeout() {
  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_before.png)" = "adb_screencap success" ] && sleep 150s &&
  [ "$(adb_screencap png=${FUNCNAME}_2_later.png)" = "adb_screencap success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2722_Support_cancel_WPS_PIN_Entry_connecting_process() {
  return ${RET_MANUAL}
}

function PFT_2724upport_cancel_WPS_PIN_Entry_waiting_process() {
  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_before.png)" = "adb_screencap success" ] && sleep 3s &&
  [ "$(wps_ops wps_pin_cancel=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_2_later.png)" = "adb_screencap success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2725_Support_cancel_WPS_PBC_connecting_process() {
  return ${RET_MANUAL}
}

function PFT_2726_Support_cancel_WPS_PBC_waiting_process() {
  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return ${RET_FAIL}

  [ "$(wps_ops wps_pbc=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_1_before.png)" = "adb_screencap success" ] && sleep 3s &&
  [ "$(wps_ops wps_pbc_cancel=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_2_later.png)" = "adb_screencap success" ] &&
  return ${RET_CHECK} || return ${RET_FAIL}
}

function PFT_2727_Make_sure_WPS_PBC_and_WPS_PIN_can_work_well_when_an_ap_has_connected() {
  return ${RET_MANUAL}
}

function PFT_5207_Can_Connect_to_WPS_PIN_Entry_with_WPA_WPA2_PSK_DHCP_disabled_SSID_broadcasted_Donot_have_static_IP() {
  return ${RET_MANUAL}
}

function PFT_5208_Can_Connect_to_WPS_PBC_Entry_with_WPA_WPA2_PSK_DHCP_disabled_SSID_broadcasted_Donot_have_static_IP() {
  return ${RET_MANUAL}
}

