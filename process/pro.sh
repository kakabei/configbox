#! /bin/bash


USAGE="
The Kane's  Tool
Copyright (C): 2023  Kane Fang
Version      : V1.0
Date         : 2016/11/09 22:21:46

Usage :$0 <options> [args]
Options:
    help   ---- Help text.
    pid    ---- process info [pid]
"

echo_help_info()
{
    echo -e "$USAGE"
}

pid_func()
{
    P=$1
    n=`ps -aux| awk '$2~/^'${P}'$/{print $0}'|wc -l`

    if [ $n -eq 0 ];then
         echo "pid no exist."
     exit

    fi
    
    echo -e "\e[32m----------------------------------------------\e[0m" 
    echo -e "process pid: ${P}"
    echo -e "process command：$(ps -aux| awk '$2~/^'$P'$/{for (i=11;i<=NF;i++) printf("%s ",$i)}')"
    echo -e "process owner:  $(ps -aux| awk '$2~/^'$P'$/{print $1}')"
    echo -e "cpu rate： $(ps -aux| awk '$2~/^'$P'$/{print $3}')%"
    echo -e "memory rate： $(ps -aux| awk '$2~/^'$P'$/{print $4}')%"
    echo -e "process start time： $(ps -aux| awk '$2~/^'$P'$/{print $9}')"
    echo -e "process runs time： $(ps -aux| awk '$2~/^'$P'$/{print $10}')"
    echo -e "process state： $(ps -aux| awk '$2~/^'$P'$/{print $8}')"
    echo -e "process virtual memory： $(ps -aux| awk '$2~/^'$P'$/{print $5}')"
    echo -e "process shared memory： $(ps -aux| awk '$2~/^'$P'$/{print $6}')"
    echo -e "\e[32m----------------------------------------------\e[0m" 

}

case "$1" in
    "help"|"-h"|"--help" )
        echo_help_info
        ;;
    "pid" )
    	pid_func $2
       ;;
    * )
       echo_help_info
       ;;
esac
