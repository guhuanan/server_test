#!/bin/bash

#######################
## Writer: huanan
## Time: 2022-03-21
## For: Server Platform System warm Reboot Test via BMC
## ./server_DC_test_via_BMC.sh  BMC-IP Host-IP
#######################

BMC_IP=$1
HOST_IP=$2
test_cycle=0
cycle_time=0

while [ 1 ]
do
    bmc_status=`ping ${BMC_IP} -c 1 -w 1 |grep % |awk '{print $6 }'`
    if [[ "${bmc_status}" == "0%" ]]
    then
        echo -e "\n\033[33m BMC Network Ready.\033[0m" 
	echo -e "\033[33m Check Host status.\033[0m"
	ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power status |grep -i "Chassis Power is off" > /dev/null
        host_off_status=$?
        if [[ "${host_off_status}" == "0" ]]
        then
            echo -e "\n\033[33m Servre status is poweroff. Send power on command.\033[0m"
	    ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power on
            power_on_cmd=$?
	    echo -e "\033[32m Send power on command done.\033[0m"
            echo -e "\033[32m Cycle number: ${test_cycle}. Time: `date` \033[0m"
	    
	    if [[ ${power_on_cmd} == "0" ]]
	    then
	        sleep 10
	        ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power status |grep -i "Chassis Power is on" > /dev/null
                host_on_status=$?
	        if [[ ${host_on_status} == "0" ]]
	        then
                    dog_time=1
	            while [ 1 ]
	    	    do
		        os_status=`ping ${HOST_IP} -c 1 -w 1 |grep % |awk '{print $6 }'`
                        if [[ "${os_status}" == "0%" ]]
                        then
                            echo -e "\033[33m OS Network Ready.\033[0m"
                            echo -e "\033[33m OS Network Ready. Power off DUT\033[0m"
		            ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power off
                            echo -e "\033[32m BMC IP: ${BMC_IP}. Host IP:${HOST_IP} \033[0m"
                            echo -e "\033[32m Cycle number: ${test_cycle}. Time: `date` \033[0m"
		            break
			else
			    echo -e "\033[33m ${dog_time} OS Network Not Ready, sleep 20s.\033[0m"
                            echo -e "\033[32m BMC IP: ${BMC_IP}. Host IP:${HOST_IP} \033[0m"
                            echo -e "\033[32m Cycle number: ${test_cycle}. Time: `date` \033[0m"
			    sleep 20
		            dog_time=$(( ${dog_time} + 1 ))
			    if [ ${dog_time} -ge 30 ]
			    then
		                ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power reset
		                cycle_time=$(( ${cycle_time} + 1 ))
                                echo -e "\033[31m Cycle number: ${cycle_time} \033[0m"
			        dog_time=0
			    fi
			fi
		    done
		    test_cycle=$(( ${test_cycle} + 1 ))
		else
	            ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power on
	            sleep 10
	        fi
            else
	        echo -e "\033[32m Run Power on command done. Sleep 60s. \033[0m"
                echo -e "\033[32m Cycle number: ${test_cycle}. Current time: `date` \033[0m"
                sleep 60
	    fi
	else
	    ipmitool -I lanplus -H ${BMC_IP} -U root -P 0penBmc chassis power off
	    sleep 10
	fi
     else
        echo -e "\033[31m BMC Network Not Ready. Sleep 10s. Current time: `date` \033[0m"
        sleep 10
    fi
done
