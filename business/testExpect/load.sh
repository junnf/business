#!/bin/bash

declare -a slots_array
declare -a ip_array

cd "/tmp/testExpect"

num=`cat ip_config.cfg | wc -l`
for ((i=1;i<=$num;i++))
do
 cat ip_config.cfg | awk '{if(NR=='''$i'''){print $2}}' | xargs -i expect expect.exp {}
 sleep 10
done
set ip [lindex $argv 0]
spawn telnet $ip
expect "login"
send "bmu852\r"
expect "word"
send "aaaabbbb\r"
expect ">"
exp_send "memShow\r"
#log_file | grep "ree" > a
puts "bbb"
cat expect.exp
puts $expect_out(buffer)
puts "aaa"
expect ">"

