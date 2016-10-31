#!/bin/bash

declare -a array_slots
declare -a array_ip
touch .temp.txt

num=`cat ip_config.cfg | wc -l`

function get_date() {
    echo -n `date +"%Y.%m.%d-%H:%M"`
}

dir_name=`get_date`
cd /tmp
mkdir $dir_name

function important_test(){
    cd $dir_name
    touch netNode.log
    for (( i = 1; i <=$num ; i++ )); do
        #statements
        array_slots[$i]=`cat ip_config.cfg | awk '{if(NR=='''$i'''){ print $1 }}'`
        array_ip[$i]=`cat ip_config.cfg | awk '{if(NR=='''$i'''){ print $2 }}'`
    done
}


# `init_prepare`
# pass!
function get_mem() {
    /usr/bin/expect<<EXP
    spawn telnet $1
    expect "login"
    send "bmu852\r"
    expect "word"
    send "aaaabbbb\r"
    expect ">"
    exp_send "memShow\r"
    log_file ".temp.txt"
    expect ">"
EXP
    free=`cat .temp.txt | grep -e 'free' | awk '{print $2}'`
    alloc=`cat .temp.txt | grep -e 'allo' | awk '{if(NR==1){print $2}}'`
    result=`echo $free $alloc | awk '{print 100*$2/($1+$2)"%"}'`
    ############!!!slots type!!
    echo -ne "Mem" >> netNode.log
    echo -ne $result >> netNode.log 
    echo -ne "    "
    echo -ne "" > .temp.txt
}

function get_spy() {
    /usr/bin/expect<<EXP
    spawn telnet $1
    expect "login"
    send "bmu852\r"
    expect "word"
    send "aaaabbbb\r"
    expect ">"
    exp_send "spy\r"
    sleep 6
    log_file ".temp.txt"
    expect ">"
    send "spyStop\r"
    except ">"
EXP
result=`cat .temp.txt | grep -B5 -i 'spyStop' | grep 'TOTAL' | awk '{print $2l}'`
    echo -ne "CPU:" >> netNode.log
    echo -ne $result >> netNode.log 
    echo -ne "    "
    echo -ne "" > .temp.txt
}


function get_t() {
    #iStrict resemble i and run once
    /usr/bin/expect<<EXP
    spawn telnet $1
    expect "login"
    send "bmu852\r"
    expect "word"
    send "aaaabbbb\r"
    expect ">"
    exp_send "i\r"
    log_file ".temp.txt"
    expect ">"
EXP
    result=`cat .temp.txt | grep -A 3 -i '\-\-\-' | grep -v '---' | awk '{if(NR<=3){print $3}}'`
    echo -ne "Task-id:" >> netNode.log
    echo -ne $result >> netNode.log 
    echo -ne "    "
    echo -ne "" > .temp.txt
}

function get_uptime() {
    /usr/bin/expect<<EXP
    spawn telnet $1
    expect "login"
    send "bmu852\r"
    expect "word"
    send "aaaabbbb\r"
    expect ">"
    exp_send "RecvLog\r"
    log_file ".temp.txt"
    expect ">"
EXP
    cat .temp.txt | grep 'Bmu' | awk '{print $4/3600"Hours"}' 
    echo -ne "Time:" >> netNode.log
    echo -ne $result >> netNode.log 
    echo -ne "    "
    echo -ne "" > .temp.txt
}

function main(){
    cd /tmp/$dir_name
    for (( i = 1; i <=$num ; i++ )); do
        #statements
        echo ${array_slots[$i]} > netNode.log
        `get_mem ${array_ip[$i]}`
        `get_spy ${array_ip[$i]}`
        `get_t ${array_ip[$i]}`
        `get_uptime ${array_ip[$i]}`
        sleep 5
    done
}
#cat value from .cfg
important_test 
main
