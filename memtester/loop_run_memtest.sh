#!/bin/bash

### Writer: Gu.huanan
### Date: 2022-03-27
### Usage: chmod a+x loop_run_memtest.sh
###        ./loop_run_memtest.sh

count=1
log_file=/data/memtester_log
mkdir -p ${log_file}
rm -f ${log_file}/*

while [ 1 ]
do
    free_memory=`free -g |grep "Mem:" |awk -F " " '{print $7}'`
    if [[ ${free_memory} -gt 8  ]]
    then
        echo -e "\n \033[32mCurrent loop: ${count}\033[0m" | tee -a ${log_file}/loop_${count}.log
        date |tee -a ${log_file}/loop_${count}.log 
	free -g
	memtester 7GB > ${log_file}/loop_${count}.log &
        let count+=1
        sleep 2
    else
        echo -e "\033[32m \n Current loop: ${count}\033[0m"
	date
        free -g
	sleep 60
    fi
done

