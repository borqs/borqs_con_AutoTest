borqs_con_AutoTest
==================

That is just a auto test tool for connectivity

Steps:
1. export STDOUT_LOG="$(pwd)/results/log_stdout.txt"
2. bash -x main.sh 2>&1 | tee ${STDOUT_LOG}
