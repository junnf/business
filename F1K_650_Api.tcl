proc loginSshF1k650{ args } {
    package require Expect
    array set argsArr $args
    global spidssh
    set res 0
    for { set i 1 } {  $i <= 5 } { incr i } {
        # logtoF1k -info "Login the CXCU for 5 times!"
        if { $i == 5 } {
            logtoF1k -info "Try 5 times and login Fail!"
            set res 0
        } else {
        after 1000
        #telnet and switch to the OS-Mode(Like SSH)
        spawn telnet root@argsArr(-ip)
        set spidssh $spawn_id
        match_max 65536
        expect { 
            -gl "*username*" {
                exp_send "fiberhome\r"
                expect "*password*" {
                    exp_send "fiberhome\r"
                    expect "NE" {
                        #expect can use?
                        logtoF1k -msg "Telnet Successfully"
                        exp_send "ostelnet 127.0.0.1\r"
                        expect "login"
                        exp_send "fiberhome\r"
                        expect "Password"
                        exp_send "fiberhome\r"
                        expect "/root>" 
                        logtoF1k -msg "Login Successfully"
                    }
                }
            }
        }
    }
    }
}

proc 
