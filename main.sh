#!/bin/bash

source $(pwd)/cases/cases.sh


function main() {
  while read oneline ; do
 
    local func=`echo $oneline | awk -F "=" '{print $1}'`  
    local limit=`echo $oneline | awk -F "=" '{print $2}'`

    if [ "$limit" = "1" ]; then
      $func
    fi

  done < $(pwd)/config.txt
}

main
