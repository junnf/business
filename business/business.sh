#!/bin/bash

#load the cfg
#test load file

declare -a pid_array

cat netNode.cfg | while read line ; do
    echo $line
done

#record time
function get_date() {
    echo -n `date +"%Y.%m.%d-%H:%M"`
}

function search_per_singledisk(){
	###use expect
	echo "Test!"

}

function find_pid_cpuinfo() {
    # for (( i = 0; i <3 ; i++ )); do
        # #statements
    # done
    #except the first line
    #3, is cpu-use ,4 , is mem-info
    echo `ps -aux | sort -r -k3 | awk '{if(NR>=2&&NR<=4){ print $3}}'`
}

function find_pid_meminfo(){
    echo `ps -aux | sort -r -k3 | awk '{if(NR>=2&&NR<=4){ print $4}}'`
}

function find_three_pid() {

    _temp=`ps -aux | sort -r -k3,4 | awk '{if(NR>=2&&NR<=4){ print $2}}'`
    # echo $_temp
    for (( i = 0; i < 3; i++ )); do
        pid_array[$i]=`echo $_temp | cut -d " " -f$[i+1]`
    done

}

#from pid get_mem_info
function get_mem(){
    _tem=$1
    ps -aux  | awk '{if('''$_tem'''==$2) print $4}' 
}

#from pid get_cpuinfo
function get_cpu(){
    _tem=$1
    ps -aux  | awk '{if('''$_tem'''==$2) print $3}' 
}

function get_fd(){
	lsof -p $1 | sort -r | uniq | grep -v "COMMAND" | wc -l
}

function get_time(){
	ps -aux | grep $1 | awk 'print $10'
}

function get_hdisk_io(){
	#not finish
	#
	echo "test result"
}

function get_hdisk_condition(){
	#not finish
	#
	echo "test result"
}

function get_queue_num(){
    free | grep "Mem" | awk '{print $3/$2*100"%"}'
}

function get_cpu_idle(){
    vmstat 
}

###test data
function test(){
    #create log-file
    log=`get_date`
    touch $log

    #record time
    echo -n "file created time: " > $log
    get_date >> $log
    echo -en "\nNetNode " >> $log
    echo -n `cat netNode.cfg | grep "node" | awk "{print $2}"` >> $log
    echo -en "\n" >> $log
    echo "pid   cpu   mem   fd"

    for (( i = 0; i <3 ; i++ )); do
            echo -n ${pid_array[$i]} "  " >> $log
            echo -n `get_cpu ${pid_array[$i]}` " " >> $log
            echo -n `get_mem ${pid_array[$i]}` " " >> $log
            echo -n `get_fd ${pid_array[$i]}` " " >> $log
            echo -n `get_time ${pid_array[$i]}` >> $log
            # echo -n " Hours" >> $log
            # echo " " >> $log
            echo -en "\n" >> $log
    done
    echo -n "\n"
    `get_hdisk_io` >> $log
    # `get_hdisk_condition` >> $log
}

find_three_pid
log=`get_date`
touch $log
get_date > $log
for (( i = 0; i < 3; i++ )); do
    echo -n ${pid_array[$i]} >> $log
done
echo -en "\n"
echo -n "Mem-used:" 
echo -n `free | grep "Mem" | awk '{print $3/$2*100"%"}'` >> $log
echo -n "Cpu-used:" 
echo -n

###cpu
`get_queue_num` >> $log


vmstat | grep -v procs | grep -v free | awk '{print }'
vmstat | grep -v procs | grep -v free | awk '{print }'
