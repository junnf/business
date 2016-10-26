#!/bin/bash

num=`cat ip_config.cfg | wc -l`
function vxworks(){
    echo $1
}

function init_prepare(){

    for ((i=1;i<$num;i++));
    do
        cat ip_config.cfg | awk '{if(NR=='''$i'''){print $2}}' | xargs -i `vxworks`
        sleep 10
    done
}

# `init_prepare`

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
}

`get_mem 127.0.0.1`

function get_t() {
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
}
