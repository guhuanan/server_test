#!/usr/bin/env bash

### Writer:Gu.Huanan
### Date: 2022-03-28
### Usage: # chmod a+x get_bmc_info_48h.sh
### Remote test:
###        # ./get_bmc_info_48h.sh BMC_IP BMC_USER BMC_PASSWORD
### Local test:
###        # ./get_bmc_info_48h.sh

par_num=$#
bmc_ip=$1
bmc_user=$2
bmc_pwd=$3
log_folder="/data/get_bmc_info"
log_file="get_bmc_info.log"

loop_count=1
run_start=`date +'%Y-%m-%d %H:%M:%S'`
start_time=$(date --date="${run_start}" +%s)
current_time=`date +%s`
test_time=0

### Check log folder
if [ ! -d ${log_folder} ]
then
    mkdir -p ${log_folder}
fi

### Check log file
if [ -f ${log_folder}/${log_file} ]
then
    mv ${log_folder}/${log_file} ${log_folder}/${log_file}_`date "+%F_%H_%M_%S"`
fi

### print usage info
function usage_print()
{
    echo -e "\033[31m Parameter number not right.                       \033[0m"
    echo -e "\033[31m Remote method need 3 parameter.                   \033[0m"
    echo -e "\033[32m get_bmc_info_48h.sh bmc_ip user_name password. \n \033[0m"
    echo -e "\033[31m Local method no need parameter.                   \033[0m"
    echo -e "\033[32m get_bmc_info_48h.sh                            \n \033[0m"
    exit 1
}

### Local function
function local_test()
{
    while [ ${test_time} -lt 172800 ]
    do
        echo -e "\033[32m\n Current time: `date`            \033[0m"  |tee -a ${log_folder}/${log_file}
        echo -e "\033[32m Current loop number: ${loop_count}\033[0m"  |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool mc info                                              |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool sel                                                  |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool sensor                                               |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool sdr                                                  |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool lan print 1                                          |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool lan print 2                                          |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool chassis status                                       |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool power status                                         |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool user list                                            |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"  |tee -a ${log_folder}/${log_file}
        ipmitool fru                                                  |tee -a ${log_folder}/${log_file}
        
        let loop_count+=1
	current_time=`date +%s`
        test_time=$(( ${current_time} - ${start_time} ))
    done
}

### Remote function
function remote_test()
{
    while [ ${test_time} -lt 172800 ]
    do
        echo -e "\033[32m\n Current time: `date`            \033[0m"                 |tee -a ${log_folder}/${log_file}
        echo -e "\033[32m Current loop number: ${loop_count}\033[0m"                 |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} mc info        |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} sel            |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} sensor         |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} sdr            |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} lan print 1    |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} lan print 2    |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} chassis status |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} power status   |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} user list      |tee -a ${log_folder}/${log_file}
        
        echo -e "\033[32m\n ###Loop number:${loop_count} ###\033[0m"                 |tee -a ${log_folder}/${log_file}
        ipmitool -I lanplus -H ${bmc_ip} -U ${bmc_user} -P ${bmc_pwd} fru            |tee -a ${log_folder}/${log_file}
        
        let loop_count+=1
	current_time=`date +%s`
        test_time=$(( ${current_time} - ${start_time} ))

    done
}

### Print run time info
function print_run_time()
{
    run_end=`date +'%Y-%m-%d %H:%M:%S'`
    echo -e "\033[32m\n\n Get BMC info 48h test end.  \033[0m"
    echo -e "\033[32m Start time: ${run_start}        \033[0m"
    echo -e "\033[32m End   time: ${run_end}  \n      \033[0m"
    echo -e "\033[32m Log path: ${log_folder}         \033[0m"
    echo -e "\033[32m Log file:                       \033[0m"
    ls -lh ${log_folder}
    echo "\n"
}

### Main function
if [ $par_num == 3 ]
then
    remote_test
    print_run_time
elif [ $par_num == 0 ]
then
    local_test
    print_run_time
else
    usage_print
fi
