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
  local info_netconfig="`adb -s ${DEVICES_MASTER} shell netcfg`"
  local info_dumpsys_wifi="`adb -s ${DEVICES_MASTER} shell dumpsys wifi`"
  local info_lsmod="`adb -s ${DEVICES_MASTER} shell lsmod`"
  local info_netstat="`adb -s ${DEVICES_MASTER} shell netstat`"
  adb -s ${DEVICES_MASTER} pull ${PUT_LOG}/aplog ${info_dir}
  adb -s ${DEVICES_MASTER} pull ${PUT_LOG}/aplog.1 ${info_dir}

  echo "########${func} INFO##########" > ${info_file}
  echo " " >> ${info_file}
  echo " " >> ${info_file}


  echo "=========PS:====================================================================================================" >> ${info_file}
  echo "ps: {" >> ${info_file}
  echo "${info_ps}" >> ${info_file}
  echo "}" >> ${info_file}
  echo " " >> ${info_file}

  echo "=========NETCONFIG:==============================================================================================" >> ${info_file}
  echo "netconfig: {" >> ${info_file}
  echo "${info_netconfig}" >> ${info_file}
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
  local count=`find $(pwd)/results/ -path "${CASE_INFO}" -prune -o -type f -print | wc -l`
  local files=`find $(pwd)/results/ -path "${CASE_INFO}" -prune -o -type f -print`

  echo "##################################################################"
  echo "#  Files Count: ${count}                                         #"
  echo "#  Cases Info Sort ...                                           #"
  echo "##################################################################"

  for file in ${files}; do
    local str_file=`echo ${file} | grep "PFT_"`
    local loc_P=`expr index ${file} 'P'`
    local cur_Dir=`expr substr ${file} ${loc_P} 8`
    if [ "${str_file}" = "" ] || [ "${loc_P}" = "0" ]; then
      continue
    fi
    mkdir -p ${CASE_INFO}/${cur_Dir}
    mv  -f ${file} ${CASE_INFO}/${cur_Dir}
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

