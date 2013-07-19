#/bin/bash

######################################################################################
###Here are the Global Variable Parameters
######################################################################################
#You may modify these value for different PUT
#-------------------------------------------------------------------------------------
#1. You should replace these files(in prepared direction) to adapt your productions
#2. Keep your PC ip address as ${PC_IP_ADDR}
#3. Modify below value
export DEVICES_MASTER="45010053454d30384790061f1a2230ab"
export DEVICES_SLAVE=""
export WIRELESS_NETWORK_WIFI_X_Y="300 190"
export ADD_NETWORK_X_Y="435 765"

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
export PC_CURL="$(pwd)/prepared/bin/curl"
export PUT_CURL="/system/bin/curl"
export PC_IPERF="$(pwd)/prepared/bin/iperf_arm"
export PUT_IPERF="/system/bin/iperf"
export OK_FAIL="$(pwd)/results/OK_FAIL.txt"
export DATA_THROUGHPUT="$(pwd)/results/RT.txt"
export CASE_INFO="$(pwd)/results/cases_info"

######################################################################################
###dut_operations.sh   :     do operations in DUT part
###tp_link_settings.sh :     do settings in AP part
###verifications.sh    :     check results (screen capture, wpa_cli)
######################################################################################
source $(pwd)/cases/PUT_operations.sh
source $(pwd)/cases/router_settings.sh
source $(pwd)/cases/verifications.sh

#####################################################################################
###Clean last test results
######################################################################################
mkdir -p ${PC_DOWNLOAD_DIR}
mkdir -p ${PNG}
mkdir -p ${CASE_INFO}
source $(pwd)/results/sort.sh
BASH_CLEAN

######################################################################################
###Here are the cases, which could be set enable or disable in config.txt file
######################################################################################

function PFT_2511_Browser_internet_via_connect_wifi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}.png)" = "browser_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2512_Wifi_status_consistent_show() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] && sleep 2s &&
  [ "$(adb_screencap png=${FUNCNAME}_open.png)" = "adb_screencap success" ]
  [ "$(close_wifi_directly)" = "close_wifi_directly success" ] && sleep 2s &&
  [ "$(adb_screencap png=${FUNCNAME}_close.png)" = "adb_screencap success" ]

  check ${FUNCNAME}
}

function PFT_2513_Manually_scan_available_AP_and_connect() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_scan.png)" = "adb_screencap success" ]
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2514_Show_AP_security_status_and_details() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_scan.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_detail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2515_Connect_to_AP_with_static_IP_when_have_no_static_on_DUT() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2516_Connect_to_AP_with_static_IP_when_have_static_IP_on_DUT() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_first_ssid success" ]
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]
  check ${FUNCNAME}
}

function PFT_2517_Modify_AP_profile_which_is_added_before() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2518_Read_configuration_about_saved_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2519_Read_detail_info_of_connected_AP_profile() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2520_Exploratory_testing_of_Wifi_UI() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2521_Download_a_file_when_connect_to_available_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(browser_ops http=${WEB_DOWNLOAD_MP3},name=${FUNCNAME}.mp3)" = "download_data_via_browser success" ] &&
  check ${FUNCNAME}
}

function PFT_2522_Wifi_icon_disappears_after_disconnect_from_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] && sleep 5s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2523_Show_signal_strength_after_connect_to_an_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2524_Show_password_option_when_input_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid show_password=true,show_password_png=${FUNCNAME}.png)" = "connect_first_ssid success" ] &&
  check ${FUNCNAME}
}

function PFT_2525_Turn_on_off_Wifi_many_times() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  for i in 1 2 3 4 5 6 7 8 9 10 ;do
    [ "$(open_wifi)" = "open_wifi success" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_open_${i}.png)" = "screen_captrue_ssid_ops success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_close_${i}.png)" = "screen_captrue_ssid_ops success" ]
  done

  check ${FUNCNAME}
}

function PFT_2526_Connect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(add_network)" = "add_network success" ] &&
  [ "$(reopen_wifi)" = "reopen_wifi success" ] && sleep 15s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2527_Test_Airplane_mode_when_wifi_is_enabled() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  for i in 1 2 3 4 5 ; do
    [ "$(airplane_ops true)" = "airplane_ops success" ] && sleep 15s &&
    [ "$(adb_screencap png=${FUNCNAME}_discon_${i}.png)" = "adb_screencap success" ]

    [ "$(airplane_ops false)" = "airplane_ops success" ] && sleep 15s &&
    [ "$(adb_screencap png=${FUNCNAME}_con_${i}.png)" = "adb_screencap success" ]
  done
  [ "$(airplane_ops false)" = "airplane_ops success" ]

  check ${FUNCNAME}
}

function PFT_2528_Can_config_static_IP_for_AP_on_DUT() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2529_Disconnect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2530_Turn_on_wifi_after_Master_Clear_the_device() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(master_clear)" = "master_clear success" ] && sleep 180s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2531_Test_WiFi_and_BT_function_when_they_are_enabled() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2532_Connect_to_AP_with_proxy_settings() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2533_Turn_on_Turn_off_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(open_wifi_directly)" = "open_wifi_directly success" ] && sleep 2s &&
  [ "$(adb_screencap png=${FUNCNAME}_open_directly.png)" = "adb_screencap success" ]

  [ "$(close_wifi_directly)" = "close_wifi_directly success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_close_directly.png)" = "adb_screencap success" ]

  [ "$(open_wifi)" = "open_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_open.png)" = "adb_screencap success" ]

  [ "$(close_wifi)" = "close_wifi success" ] && sleep 3s &&
  [ "$(adb_screencap png=${FUNCNAME}_close.png)" = "adb_screencap success" ]

  check ${FUNCNAME}
}

function PFT_2534_Start_to_auto_scan_after_turn_on_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2535_Auto_refresh_scan_results_every_period_of_time() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_before.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(set_ap_ops ssid_24g='PFT_2535')" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_later.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2536_manually_scan_available_ap() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(scan_manual)" = "scan_manual success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_scan.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2537_Show_AP_signal_strength_SSID_security_type_of_scanned_network_from_AP_list_after_auto_scan() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_default.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_none.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_wep.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate-'first',png=${FUNCNAME}_eap.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2538_Show_different_security_type_and_Signal_strength_for_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_default.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_wep.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_80211eap.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2539_Support_show_password_option_when_input_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return
  [ "$(connect_first_ssid show_password=true,show_password_png=${FUNCNAME}_con.png)" = "connect_first_ssid success" ]

  [ "$(add_network mode=${SECURT_MODE_WEP},password=${SECURT_MODE_WEP},show_password=true,show_password_png=${FUNCNAME}_pw_wep.png)" = "add_network success" ]
  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2},show_password=true,show_password_png=${FUNCNAME}_pw_wpa2.png)" = "add_network success" ]
  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},show_password=true,show_password_png=${FUNCNAME}_pw_eap.png)" = "add_network success" ]

  check ${FUNCNAME}
}

function PFT_2540_Connect_Ap_manually_and_show_signal_strength_and_read_detail_info_of_connecting_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2541_Show_WiFi_icon_for_connected_network_and_icon_will_disappear_after_turn_off_WiFi() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  {
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]
    {
      sleep 3s
      adb_screencap png=${FUNCNAME}_downloading.png
    }&
    [ "$(browser_ops http=${WEB_DOWNLOAD_T2},file_name=${FUNCNAME}.mp3)" = "browser_ops success" ] &&
    [ "$(close_wifi)" = "close_wifi success" ] && [ "$(adb_screencap png=${FUNCNAME}_close.png)" = "adb_screencap success" ]
    [ "$(open_wifi)" = "open_wifi" ] && sleep 5s && [ "$(adb_screencap png=${FUNCNAME}_open.png)" = "adb_screencap success" ]
  }
  check ${FUNCNAME}
}

function PFT_2542_Connect_to_at_least_two_APs_successively_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2543_Disconnect_and_Connect_to_a_AP_automatically() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con1.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 15s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_discon1.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_discon2.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con2.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2544_Cannot_connect_AP_successfully_with_wrong_password() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=0987654321)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_wep_discon_len_10.png)" = "screen_captrue_ssid_ops success" ]

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_wep_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_WPA_WPA2})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_wpa2_discon_len_10.png)" = "screen_captrue_ssid_ops success" ]

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_wpa2_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_ENTERPRISE_MIXED_MODE})" = "set_ap_ops success" ] && {
    [ "$(connect_first_ssid password=87654321)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_eap_discon_len_10.png)" = "screen_captrue_ssid_ops success" ]

    [ "$(connect_first_ssid password=112233445)" = "connect_first_ssid fail" ] && sleep 10s &&
    [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_eap_discon_len_9.png)" = "screen_captrue_ssid_ops success" ]
  }

  check ${FUNCNAME}
}

function PFT_2546_Modify_network_2() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2547_Forget_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2548_Auto_connect_to_other_AP_between_BSSIDs_with_same_SSID() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2549_Support_AP_Show_advanced_options() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2550_Can_config_static_IP_for_AP_on_PUT() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2551_AP_channel_1_13() {
  work_tag ${FUNCNAME}

  [ "$(master_clear)" = "master_clear success" ] && {
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
      [ "$(set_ap_ops func=${FUNCNAME},channel_24g=${i})" = "set_ap_ops success" ] &&
      [ "$(clean_wifi_operations)" = "clean_wifi_operations success" ] &&
      [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
      [ "$(screen_captrue_ssid_ops ${FUNCNAME}_${i}.png)" = "screen_captrue_ssid_ops success" ]
    done
  }

  check ${FUNCNAME}
  echo "${FUNCNAME} [!!!]: Please Plug in SIM Card And Do again" >> ${OK_FAIL}
}

function PFT_2552_Reconnect_priority_test() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2553_WiFi_throughput_test() {
  work_tag ${FUNCNAME}

  for i in 1 2 3 ;do
    DUT_Upload_Data_Throughput_Network_80211BG_RSSI_50_to_70 png=${FUNCNAME}_bg_50_70_up_${i}.png
    DUT_Download_Data_Throughput_Network_80211BG_RSSI_50_to_70 png=${FUNCNAME}_bg_50_70_down_{i}.png

    DUT_Upload_Data_Throughput_Network_80211A_RSSI_50_to_70 png=${FUNCNAME}_a_50_70_up_${i}.png
    DUT_Download_Data_Throughput_Network_80211A_RSSI_50_to_70 png=${FUNCNAME}_a_50_70_down_${i}.png

    DUT_Upload_Data_Throughput_Network_80211N_RSSI_50_to_70 png=${FUNCNAME}_n_50_70_${i}_up.png
    DUT_Download_Data_Throughput_Network_80211N_RSSI_50_to_70 png=${FUNCNAME}_n_50_70_${i}_down.png
  done

  check ${FUNCNAME}
  echo "${FUNCNAME} [!!!]: Please Keep RSSI [70, 80] And Do again" >> ${OK_FAIL}
}

function PFT_2554_Add_a_AP_profile_with_None() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2555_Add_a_AP_profile_with_WEP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},security_mode_24g=${SECURT_MODE_WEP})" = "set_ap_ops fail" ] && return

  [ "$(add_network mode=${SECURT_MODE_WEP})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2556_Add_a_AP_profile_with_WPA2() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return

  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}


function PFT_2557_Support_add_use_configured_AP_with_None_WEP_WPA2_802_11x_EAP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE},ssid='PFT_2557_NONE')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_none.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WPA_WPA2},ssid='PFT_2557_WPA_WPA2')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_wpa_wpa2.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_WEP},ssid='PFT_2557_WEP')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_wep.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_ENTERPRISE_MIXED_MODE},ssid='PFT_2557_EAP')" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_eap.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2558_Can_support_edit_SSID_of_wifi() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2559_Password_length_test_for_WiFi_with_WPA2_mode() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_l8',mode=${SECURT_MODE_WPA_WPA2},password='Aa%#&@$',show_password=true,show_password_png=${FUNCNAME}_l8_pw.png)" = "add_network success" ] && sleep 3

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_8',mode=${SECURT_MODE_WPA_WPA2},password='AaB%#&@$',show_password=true,show_password_png=${FUNCNAME}_8_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_8.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_m8',mode=${SECURT_MODE_WPA_WPA2},password='AaBBB%#&@$',show_password=true,show_password_png=${FUNCNAME}_m8_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_m8.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2559_mm8',mode=${SECURT_MODE_WPA_WPA2},password='abcdefghijklmnopqrstuvwxyz',show_password=true,show_password_png=${FUNCNAME}_mm8_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_mm8.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2560_Password_length_test_for_WiFi_with_WEP_mode() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_l16',mode=${SECURT_MODE_WEP},password='Aa%#&@$',show_password=true,show_password_png=${FUNCNAME}_l16_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_l16.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_16',mode=${SECURT_MODE_WEP},password='AaBbCcDdEeF%#&@$',show_password=true,show_password_png=${FUNCNAME}_16_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_16.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_m16',mode=${SECURT_MODE_WEP},password='AaBBBCcDdEeFfGg%#&@$',show_password=true,show_password_png=${FUNCNAME}_m16_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_m16.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops success" ] &&
  [ "$(add_network ssid='PFT_2560_mm16',mode=${SECURT_MODE_WEP},password='abcdefghijklmnopqrstuvwxyz',show_password=true,show_password_png=${FUNCNAME}_mm16_pw.png)" = "add_network success" ] && sleep 3s &&
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_mm16.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2563_WiFi_frequency_band() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}.png)" = "wifi_advances_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2564_Default_by_wifi_frequency_band() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}.png)" = "wifi_advances_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2566_24G_only_with_wifi_frequency_band() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_default.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(wifi_advances_ops enable_freq_band=true,set_freq_band='24g')" = "wifi_advances_ops success" ] &&
  [ "$(wifi_advances_ops enable_freq_band=true,show_freq_band=true,png=${FUNCNAME}_24g.png)" = "wifi_advances_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_24g.png)" = "screen_captrue_ssid_ops success" ] &&
  check ${FUNCNAME}
}

function PFT_2567_Never_break_wifi_connection_if_cable_is_plugged_in() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2568_Support_view_IP_MAC_address() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] &&
  [ "$(wifi_advances_ops show_ip_mac=true,png=${FUNCNAME}_ip_mac.png)" = "wifi_advances_ops success" ]
  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(wifi_advances_ops show_ip_mac=true,png=${FUNCNAME}_no_ip_mac.png)" = "wifi_advances_ops success" ]
  check ${FUNCNAME}
}

function PFT_2569_Turn_on_Turn_off_open_network_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2570_Open_network_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function Should_enter_into_wifi_setting_screen_when_tapping_WiFi_networks_available_from_notification() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2572_Keep_Wi_Fi_on_during_sleep_Always() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2573_Keep_WiFi_on_during_sleep_Only_when_plugged_in() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2574_Keep_WiFi_on_during_sleep_Never_increase_data_usage() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2575_Periodic_scan_test() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2576_Add_a_ap_with_open_manually() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(add_network ssid='PFT_2576',mode=${SECURT_MODE_DISABLE})" = "add_network success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_tail.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(screen_captrue_ssid_ops locate='last',png=${FUNCNAME}_last.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2577_Connect_a_open_AP_from_scan_result() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops ${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops func=${FUNCNAME},security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid locate='first',mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]
  check ${FUNCNAME}
}

function PFT_2578_Connect_to_a_hidden_AP_with_OPEN() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_before.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_later.png)" = "screen_captrue_ssid" ] &&
  check ${FUNCNAME}
}

function PFT_2579_Modify_AP_with_static_IP_OPEN_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2580_Modify_AP_with_static_IP_proxy_settings_OPEN_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2581_Modify_AP_with_proxy_settings_OPEN_manually() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2582_Add_a_AP_with_OPEN_manually_Forget_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2583_Ap_with_OPEN_Disable_DHCP_Hide_SSID_Manual_add_Donot_have_static_IP_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_abt_ip.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2584_Ap_with_OPEN_Disable_DHCP_Hide_SSID_Manual_add_have_static_IP_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE},enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2585_Ap_with_Open_Disable_DHCP_Show_SSID_have_static_IP_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE},enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2586_AP_with_Open_Disable_DHCP_Show_SSID_Donot_have_static_IP_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid fail" ]
  sleep 10s
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_abt_ip.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2587_Ap_with_OPEN_Enable_DHCP_Hide_SSID_Manual_add_Donot_have_static_IP_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops fail" ] && return

  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network mode=${SECURT_MODE_DISABLE})" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2588_AP_with_Open_Enable_DHCP_Show_SSID_Donot_have_static_IP_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops fail" ] && return

  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2589_Connect_AP_with_802_11_b_and_802_11_g_and_802_11_n() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_B})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_B_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_G})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_G_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_DISABLE},network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid mode=${SECURT_MODE_DISABLE})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_N_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2590_Add_a_AP_with_WPA_WPA2_PSK_manually_Forget_AP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2591_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP()
{
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2592_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2593_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2594_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2595_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2596_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password='87654321')" = "connect_first_ssid fail" ]
  sleep 10s
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2597_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2598_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2599_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2600_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2601_AP_with_WPA_WPA2_PSK_Enable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops)" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops)" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}


function PFT_2602_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2603_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2604_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_TKIP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2605_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2606_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2607_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321')" = "add_network fail" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2608_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2609_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2610_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2611_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2612_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2613_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321',enable_advances=true)" = "add_network fail" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2614_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_Donot_have_static_IP_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid fail" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}


function PFT_2615_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2616_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png,lan_proto=${DHCP_SERVER_DISABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2617_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2618_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}


function PFT_2619_AP_with_WPA_WPA2_PSK_Disable_DHCP_Show_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid enable_advances=true)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png,lan_proto=${DHCP_SERVER_DISABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2620_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Incorrect_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network password='87654321',enable_advances=true)" = "add_network fail" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function  PFT_2621_Ap_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_WPA_PSK_TKIP_WPA_PSK_AES_WPA2_PSK_TKIP_WPA2_PSK_AES_Security_Auto_select_encryption_Auto_select_Manual_add_Donot_have_static_IP_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ]
  [ "$(add_network)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}


function PFT_2622_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_WPA_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2623_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png,lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA_PERSONAL},crypto_24g=${CRYPT_24G_AES})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2624_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_TKIP_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_TKIP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2625_AP_with_WPA_WPA2_PSK_Enable_DHCP_Hide_SSID_WPA2_PSK_AES_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WPA2},crypto_24g=${CRYPT_24G_AES},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}


function PFT_2626_AP_with_WPA_WPA2_PSK_Disable_DHCP_Hide_SSID_Security_Auto_select_encryption_Auto_select_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true)" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2627_Connect_AP_with_802_11_b_802_11_g_802_11_n() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_WPA2},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_B})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_b_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_WPA2},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_G})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_g_con.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WPA_WPA2},channel_width_24g=${CHANNEL_WIDTH_24},network_mode_24g=${NETWORK_MODE_N})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid)" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_n_con.png)" = "screen_captrue_ssid_ops success" ]
  check ${FUNCNAME}
}

function PFT_2631_AP_with_WEP_ASCII_open_authentication_Enable_DHCP_Show_SSID_64_bit_Donot_have_static_IP_Correct_pasWEP_ASCII_Enable_DHCP_Show_SSID_bit_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password=${SSID_PASSWORD_WEP})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2632_AP_with_WEP_ASCII_open_authentication_Enable_DHCP_Show_SSID_128_bit_Donot_have_static_IP_Correct_pasWEP_ASCII_Enable_DHCP_Show_SSID_bit_Donot_have_static_IP_Correct_password_Auto_connect_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP_128},passphrase_24g=${SSID_PASSWORD_WEP_128},encypt_wep='128')" = "set_ap_ops success" ] &&
  [ "$(connect_first_ssid password=${SSID_PASSWORD_WEP_128})" = "connect_first_ssid success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${SECURT_MODE_WEP},passphrase_24g=${SSID_PASSWORD_WEP_128},encypt_wep='128')" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2633_Ap_with_WEP_ASCII_open_authentication_Disable_DHCP_Hide_SSID_64bit_Manual_add_have_static_IP_correct_password_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true,password=${SSID_PASSWORD_WEP})" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}


function PFT_2633_Ap_with_WEP_ASCII_open_authentication_Disable_DHCP_Hide_SSID_128bit_Manual_add_have_static_IP_correct_password_Forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops png=${FUNCNAME}_hide.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(add_network enable_advances=true,password=${SSID_PASSWORD_WEP_128})" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png})" = "browser_ops success" ]

  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_discon.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},ssid_broadcast_24g=${SSID_BROADCAST_DISENABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_recon.png)" = "screen_captrue_ssid_ops success" ]

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2636_Ap_with_WEP_ASCII_open_authentication_mode_Disable_DHCP_Show_SSID_64bit_128bit_have_static_IP_incorrect_password_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return


function PFT_2636_Ap_with_WEP_ASCII_open_authentication_mode_Disable_DHCP_Show_SSID_64bit_128bit_have_static_IP_incorrect_password_forget_AP() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops func=${FUNCNAME})" = "clean_wifi_ops fail" ] && return

  [ "$(set_ap_ops security_mode_24g=${SECURT_MODE_WEP},lan_proto=${DHCP_SERVER_DISABLE},passphrase_24g=${SSID_PASSWORD_WEP})" = "set_ap_ops success" ] &&
  [ "$(add_network enable_advances=true,password="12345678901234567890654321")" = "add_network success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&

  [ "$(forget_first_ssid)" = "forget_first_ssid success" ] &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_forget_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(set_ap_ops network_mode_24g=${NETWORK_MODE_DISABLE})" = "set_ap_ops success" ] && sleep 10s &&
  [ "$(screen_captrue_ssid_ops locate='head',png=${FUNCNAME}_dis_head.png)" = "screen_captrue_ssid_ops success" ] &&
  [ "$(screen_captrue_ssid_ops locate='tail',png=${FUNCNAME}_dis_tail.png)" = "screen_captrue_ssid_ops success" ]

  check ${FUNCNAME}
}

function PFT_2718_WPS_PBC_with_WPA_WPA2_DHCP_enabled_SSID_enable() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return

  for i in 1 2 3 ; do
    [ "$(wps_ops wps_pbc=true)" = "wps_ops success" ] &&
    [ "$(set_ap_ops wps_enable=true,wps_button_tap=true)" = "set_ap_ops success" ] &&
    sleep 30s && cursor_click &&
    [ "$(adb_wpa_cli_bssid_status)" = "adb_wpa_cli_bssid_status success" ] &&
    [ "$(screen_captrue_ssid_ops locate='first',png=${FUNCNAME}_con.png)" = "screen_captrue_ssid_ops success" ] &&
    [ "$(browser_ops http=${WEB_INDEX},png=${FUNCNAME}_web.png)" = "browser_ops success" ] &&
    check ${FUNCNAME} && return
  done
}

function PFT_2719_WPS_PIN_Entry_with_WPA_WPA2_DHCP_enabled_SSID_broadcasted() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2720_WPS-PIN_timeout() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_before.png)" = "adb_screencap success" ] && sleep 150s &&
  [ "$(adb_screencap png=${FUNCNAME}_later.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME}
}

function PFT_2721_WPS-PBC_timeout() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_before.png)" = "adb_screencap success" ] && sleep 150s &&
  [ "$(adb_screencap png=${FUNCNAME}_later.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME}
}

function PFT_2722_Support_cancel_WPS_PIN_Entry_connecting_process() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2724upport_cancel_WPS_PIN_Entry_waiting_process() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return

  [ "$(wps_ops wps_pin=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_before.png)" = "adb_screencap success" ] && sleep 3s &&
  [ "$(wps_ops wps_pin_cancel=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_later.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME}
}

function PFT_2725_Support_cancel_WPS_PBC_connecting_process() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_2726_Support_cancel_WPS_PBC_waiting_process() {
  work_tag ${FUNCNAME}

  [ "$(clean_wifi_ops)" = "clean_wifi_ops fail" ] && return

  [ "$(wps_ops wps_pbc=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_before.png)" = "adb_screencap success" ] && sleep 3s &&
  [ "$(wps_ops wps_pbc_cancel=true)" = "wps_ops success" ] &&
  [ "$(adb_screencap png=${FUNCNAME}_later.png)" = "adb_screencap success" ] &&
  check ${FUNCNAME}
}

function PFT_2727_Make_sure_WPS_PBC_and_WPS_PIN_can_work_well_when_an_ap_has_connected() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_5207_Can_Connect_to_WPS_PIN_Entry_with_WPA_WPA2_PSK_DHCP_disabled_SSID_broadcasted_Donot_have_static_IP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

function PFT_5208_Can_Connect_to_WPS_PBC_Entry_with_WPA_WPA2_PSK_DHCP_disabled_SSID_broadcasted_Donot_have_static_IP() {
  work_tag ${FUNCNAME}
  manual ${FUNCNAME}
}

