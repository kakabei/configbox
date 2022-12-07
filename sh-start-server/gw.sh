#!/bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:$PATH

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

GAME_NUM=8

USAGE="
The Great Wall Game Service Tool
Copyright (C): 2016  Mokylin·Mokyqi
Version      : V1.0
Date         : 2016/11/09 22:21:46

Usage :$0 <options> [args]
Options:
    help              ---- Help text.
  
    start             ---- Start all service.
    stop              ---- Stop all service.
    restart           ---- Restart all service. 
    list              ---- List all service.
    clean             ---- Clean log files.

    -e [server_name]  ---- Stop one service.
    -s [server_name]  ---- Start one service.  
    -gs [id_count]    ---- Start game_server id.
    -v [server_name]  ---- Start service by valgrind.
    -vgs [id]         ---- Start game_server id  by valgrind.

The Service's Root Path: $ROOT
"

PRO_NAME=(login_server register_server game_server robot_server global_server  world_server db_server dip_server record_server)

##################################################################

echo_help_info()
{
    echo -e "$USAGE"
}

stop_server()
{
    if [[ -n $1 ]] && [[ $1 == "-9" ]]; then
        echo "force stop ..."
        pids=`ps x | grep $ROOT/game_server/game_server | grep -v grep | sed 's/^[ \t]*//' | cut -d ' ' -f 1`
        for pid in $pids ; do 
            echo killing $pid $ROOT/game_server/game_server 
            kill -9 $pid
        done
   
        for item in ${PRO_NAME[@]};do 
            pids=`ps x | grep  $ROOT/$item/$item | grep -v grep | sed 's/^[ \t]*//' | cut -d ' ' -f 1`
            for pid in $pids ; do 
                echo killing $pid $ROOT/$item/$item
               kill -9 $pid
            done
        done
    else
        for item in ${PRO_NAME[@]};do 
           killall   $ROOT/$item/$item
        done
    fi 
}

chmod_()
{
   for item in ${PRO_NAME[@]};do 
       /usr/bin/chmod 777 $ROOT/$item/$item
   done 
}

start_server() 
{
   
    for item in ${PRO_NAME[@]};do
        if [ $item != "game_server" ]; then
                $ROOT/$item/$item
        fi
    done
    if [ ! -n "$1" ]; then
        start_game_server -gs $GAME_NUM
    else
       echo $1
       start_game_server -gs $1
    fi
}

restart_server()
{
    stop_server
    start_server $1
}

list_server()
{
    for item in ${PRO_NAME[@]};do 
        ps -ef | grep $item | grep -v "grep" | grep -v "cross"
    done
}

stop_one()
{
    if [ "-e" == $1 ]; then
        killall  $ROOT/$2/$2
    else
       echo_help_info
    fi
}

start_one()
{
    if [ "-s" == $1 ]; then 
        $ROOT/$2/$2
    else
        echo_help_info
    fi
}

start_game_server()
{
    if [ "-gs" == $1 ]; then
        for((id=1;id<=$2;id++));do
            $ROOT/game_server/game_server $id 
        done
    else 
       echo_help_info
    fi
}

clean_log_files()
{
    find $ROOT  -name "err*.txt" -print -exec rm -rf {} \;
    find $ROOT  -name "out_*.txt" -print -exec rm -rf {} \;
    find $ROOT  -name "Log*" -print -exec rm -fr {} \;
    find $ROOT  -name "core*" -print -exec rm -rf {} \;
    find $ROOT  -name "*.log" -print -exec rm -fr {} \;

}

valgrind_start()
{
    if [ "-v" == $1 ]; then
        /usr/bin/valgrind --tool=callgrind  --trace-children=yes \
                          $ROOT/$2/$2
   else
       echo_help_info
   fi
}

valgrind_gs_start()
{
    if [ "-vgs" == $1 ]; then
        /usr/bin/valgrind --tool=callgrind  --trace-children=yes \
                          $ROOT/game_server/game_server $2
    else 
       echo_help_info
    fi
}

#########################################################

ulimit -c unlimited

case "$1" in
    "help"|"-h"|"--help" )
        echo_help_info 
        ;; 
    "start" )
        chmod_ 
    start_server $2
        ;;
    "stop")
        stop_server $2
        ;;
    "restart")
        restart_server $2
        ;;    
    "list")
        list_server
        ;;
    "clean")
        clean_log_files
        ;;
    "-e")
        stop_one $1 $2
        ;;
    "-s")
        start_one $1 $2
        ;; 
    "-gs")
       start_game_server $1 $2
       ;;
    "-v")
       valgrind_start $1 $2
       ;;
    "-vgs")
       valgrind_gs_start $1 $2
       ;; 
    * ) 
       echo_help_info 
       ;; 
esac
