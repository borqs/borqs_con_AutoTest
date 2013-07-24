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
    #Clean last case logs
    echo "" > ${STDOUT_LOG}
    sleep 1s

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
        elif [ "${ret}" = "${RET_MANUAL}" ]; then
          times_manual=`expr ${times_manual} + 1`
          OPS_MANUAL ${func}
        else 
          OPS_RET ${func} "${ret}"
        fi

        #Get some information, such as ps, aplog, dumpsys wifi .etc
        CUR_WIFI_INFO func=${func}
      echo "}  LOG END << ${func}"
    fi

    #Save current screen buffer as a file. 
    cat ${STDOUT_LOG} > $(pwd)/results/${func}_log.txt &
    #Sort these files.
    sleep 5s
    PFT_XXXX_SORT
  #Clean current logs 
  done < $(pwd)/config.txt

  #Summarize test results
  echo "################################################################################################################"
  echo "##############################TEST RESULTS : ###################################################################"
  echo "#####Total Cases: ${times_total}"
  echo "#####        Success Cases: ${times_ok}, Fail Cases: ${times_fail}"
  echo "#####        Check   Cases: ${times_check}, Mannual Cases: ${times_manual}"
  echo "#####        Fail Rate: `expr ${times_fail} \* 100 / ${times_total}`"
  echo "################################################################################################################"
}

main
