#!/bin/bash

##########################################################################################################
###eg: We need get TESTLINK ID PFT_2513 from file.
###/home/b734/auto_tester/workspace/results/png/PFT_2513_Manually_scan_available_AP_and_connect.png
##########################################################################################################
export CASES_INFO=$(pwd)/cases_info
export DOWNLOAD=$(pwd)/download
export LOG=$(pwd)/log.txt*
export OK_FIAL=$(pwd)/OK_FAIL.txt*
export PNG=$(pwd)/png
export RT=$(pwd)/RT.txt*

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
    mkdir -p ${CASES_INFO}/${cur_Dir}
    cp  -fr ${file} ${CASES_INFO}/${cur_Dir}
  done

  echo "##################################################################"
  echo "# Case Info Sort Over                                            #"
  echo "##################################################################"
}

function BASH_CLEAN() {
  echo "##################################################################"
  echo "#  Clean Last Test Info...                                       #"
  echo "##################################################################"

  rm -fr ${CASES_INFO}/*
  rm -fr ${DOWNLOAD}/*
  rm -fr ${LOG}
  rm -fr ${OK_FIAL}
  rm -fr ${PNG}/*
  rm -fr ${RT}

  echo "##################################################################"
  echo "#  Clean Last Test Info Over                                     #"
  echo "##################################################################"
}
