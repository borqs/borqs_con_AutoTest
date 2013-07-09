#!/bin/bash

##########################################################################################################
###eg: We need get TESTLINK ID PFT_2513 from file.
###/home/b734/auto_tester/workspace/results/png/PFT_2513_Manually_scan_available_AP_and_connect.png
##########################################################################################################
function png_sort(){
  local file_size=`ls $(pwd)/png/ -l | wc -l`
  local cut_start=`expr length "$(pwd)/png/"`
  local cut_end=`expr $cut_start + 8` 
  local file_names=$(find $(pwd)/png/ -type f -name *.png -print)
  local dir_names=$(find $(pwd)/png/ -type f -name *.png -print | cut -c $(expr ${cut_start} + 1)-${cut_end})
  
  for dir in ${dir_names} ;do 
    for file in ${file_names} ; do
      if [ "${file/${dir}/}" = "${file}" ]; then
        continue
      else
        mkdir -p $(pwd)/cases_info/${dir}
        cp -f ${file} $(pwd)/cases_info/${dir}
      fi
    done
  done

}

function download_sort(){
  local file_size=`ls $(pwd)/download/ -l | wc -l`
  local cut_start=`expr length "$(pwd)/png/"`
  local cut_end=`expr $cut_start + 13` 
  local file_names=$(find $(pwd)/download/ -type f -name *.png -print)
  local dir_names=$(find $(pwd)/download/ -type f -name *.png -print | cut -c $(expr ${cut_start} + 6)-${cut_end})

  for dir in ${dir_names} ;do 
    for file in ${file_names} ; do
      if [ "${file/${dir}/}" = "${file}" ]; then
        continue
      else
        mkdir -p $(pwd)/cases_info/${dir}
        cp -f ${file} $(pwd)/cases_info/${dir}
      fi
    done
  done

}
