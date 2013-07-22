# /bin/bash

function CUR_WIFI_INFO() {
  local arg=$1
  local func=${FUNCNAME}

  [ "${arg}" != "" ] &&
  for i in 1; do
    local var=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $1} '`
    local value=`echo $arg | awk -F "," '{ print $"'"$i"'" }' | awk -F "=" '{ print $2} '`
    case $var in
      "func")
        func=${value}
      ;;
    esac
  done

  local info_dir="${CASE_INFO}/`echo ${func} | cut -c1-8`"
  mkdir -p ${info_dir}
  local info_file="${info_dir}/${func}_info.txt"
  local info_ps="`adb -s ${DEVICES_MASTER} shell ps`"
  local info_ifconfig="`adb -s ${DEVICES_MASTER} shell busybox ifconfig`"
  local info_dumpsys_wifi="`adb -s ${DEVICES_MASTER} shell dumpsys wifi`"
  local info_lsmod="`adb -s ${DEVICES_MASTER} shell lsmod`"
  local info_netstat="`adb -s ${DEVICES_MASTER} shell netstat`"
  local info_aplog="`adb -s ${DEVICES_MASTER} pull ${PUT_LOG} ${info_dir}`"

  echo "########${func} INFO##########" > ${info_file}
  echo " " >> ${info_file}
  echo " " >> ${info_file}


  echo "=========PS:====================================================================================================" >> ${info_file}
  echo "ps: {" >> ${info_file}
  echo "${info_ps}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}
  
  echo "=========IFCONFIG:==============================================================================================" >> ${info_file}
  echo "ifconfig: {" >> ${info_file}
  echo "${info_ifconfig}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}

  echo "=========DUMPSYS WIFI:==========================================================================================" >> ${info_file}
  echo "dumpsys wifi: {" >> ${info_file}
  echo "${info_dumpsys_wifi}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}

  echo "=========LSMODE:================================================================================================" >> ${info_file}
  echo "lsmod: {" >> ${info_file}
  echo "${info_lsmod}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}

  echo "=========NETSTAT:===============================================================================================" >> ${info_file}
  echo "netstat: {" >> ${info_file}
  echo "${info_netstat}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}

  echo "=========aplog:=================================================================================================" >> ${info_file}
}


##########################################################################################################
###eg: We need get TESTLINK ID PFT_2513 from file.
###/home/b734/auto_tester/workspace/results/png/PFT_2513_Manually_scan_available_AP_and_connect.png
##########################################################################################################

function PFT_XXXX_SORT(){
  local count=`find ./ -type f -print | wc -l`
  local files=`find ./ -type f -print`

  echo "##################################################################"
  echo "#  Files Count: ${count}                                         #"
  echo "#  Cases Info Sort ...                                           #"
  echo "##################################################################"

  for file in ${files}; do
    local loc_P=`echo ${file} | grep "PFT_" | expr index ${file} 'P'`
    local cur_Dir=${file:${loc_P}:7}
    if [ "${loc_P}" = "0" ]; then
      continue
    fi  
    mkdir -p ${CASE_INFO}/${cur_Dir}
    cp  -fr ${file} ${CASE_INFO}/${cur_Dir}
  done

  echo "##################################################################"
  echo "# Case Info Sort Over                                            #"
  echo "##################################################################"
}

function BASH_CLEAN() {
  echo "##################################################################"
  echo "#  Clean Last Test Info...                                       #"
  echo "##################################################################"

  mkdir -p ${CASE_INFO} && rm -fr ${CASE_INFO}/*
  mkdir -p ${PC_DOWNLOAD_DIR} && rm -fr ${PC_DOWNLOAD_DIR}/*
  mkdir -p ${PNG} && rm -fr ${PNG}/*
  rm -f ${PC_LOG} && rm -f ${PC_RT} && rm -f ${OK_FAIL}

  echo "##################################################################"
  echo "#  Clean Last Test Info Over                                     #"
  echo "##################################################################"
}
