#!/bin/bash

#load the cfg
#test load file

declare -a pid_array

cat netNode.cfg | while read line ; do
    echo $line
done

#record time
function get_date() {
    echo `date +"%Y.%m.%d %H:%M"`
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
    ps -aux | grep $1 | awk '{print $4}'
}

#from pid get_cpuinfo
function get_cpu(){
    ps -aux | grep $1 | awk '{print $3}'
}

echo $pid_array

find_three_pid
echo ${pid_array[#]}
# cat netNode.cfg | grep -v '#' | cut -d',' -f-1

#create log-file
log=`get_date`
touch $log

#record time
echo -n "文件创建时间" > $log
`get_date` >> $log


