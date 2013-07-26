#!/bin/bash

source $(pwd)/cases/cases.sh


function main() {
  local times_total=0
  local times_ok=0
  local times_fail=0
  local times_check=0
  local times_manual=0
  #Clean last test results
  BASH_CLEAN

  while read oneline ; do
    local func=`echo ${oneline} | awk -F "=" '{print $1}'`  
    local enabled=`echo ${oneline} | awk -F "=" '{print $2}'`

    if [ "${enabled}" = "1" ]; then
      echo "LOG BEGIN: {  ${func}"
        times_total=`expr ${times_total} + 1`
	OPS_TAG ${func}
        ${func}
        local ret="$?"

        if [ "${ret}" = "${RET_CHECK}" ]; then
          times_check=`expr ${times_check} + 1`
          OPS_CHECK ${func}
        elif [ "${ret}" = "${RET_OK}" ]; then
          times_ok=`expr ${times_ok} + 1`
          OPS_OK ${func}
        elif [ "${ret}" = "${RET_FAIL}" ]; then
          times_fail=`expr ${times_fail} + 1`
          OPS_FAIL ${func}
          adb_screencap png=${func}_fail.png
        elif [ "${ret}" = "${RET_MANUAL}" ]; then
          times_manual=`expr ${times_manual} + 1`
          OPS_MANUAL ${func}
        else 
          OPS_RET ${func} "${ret}"
          adb_screencap png=${func}_error.png
        fi

        #Get some information, such as ps, aplog, dumpsys wifi .etc
        CUR_WIFI_INFO func=${func}
      echo "}  LOG END << ${func}"
      #Sort these files.
      PFT_XXXX_SORT
    fi
  done < $(pwd)/config.txt

  #Summarize test results
  echo "#########################################################################################################" >> ${OK_FAIL}
  echo "##############################TEST RESULTS : ############################################################" >> ${OK_FAIL}
  echo "#####Total Cases: ${times_total}"                                                                          >> ${OK_FAIL}
  echo "#####        Success Cases: ${times_ok}, Fail Cases: ${times_fail}"                                        >> ${OK_FAIL}
  echo "#####        Check   Cases: ${times_check}, Mannual Cases: ${times_manual}"                                >> ${OK_FAIL}
  echo "#####        Fail Rate: `expr ${times_fail} \* 100 / ${times_total}` %"                                    >> ${OK_FAIL}
  echo "#########################################################################################################" >> ${OK_FAIL}
}

main
