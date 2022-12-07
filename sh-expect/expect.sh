#!/usr/bin/expect
set IP [lindex $argv 0]
set USER user-name
set Password 12345678

spawn ssh $USER@$IP
expect {
"yes/no" {send "yes"; exp_continue}
"password:" {send "$Password"}
}
interact