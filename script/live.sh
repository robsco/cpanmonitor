#!/bin/bash

APP_NAME=cpanmonitor
APP_PATH=/home/rob/www.cpanmonitor.org/live
APP_USER=rob
SOCKET_FILE=$APP_PATH/$APP_NAME.socket
PID_PATH=$APP_PATH/$APP_NAME.pid
LOG_FILE=$APP_PATH/log/cpanmonitor-fcgi-startup.log
NPROC=5
export CATALYST_CONFIG_LOCAL_SUFFIX=live
export CPANMONITOR_DB=live

case $1 in
start)
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        echo " LIVE $APP_NAME already running"
        exit 0
    fi

    echo "Starting LIVE $APP_NAME (${APP_NAME}_fastcgi.pl)..."

    touch $PID_PATH
    chown $APP_USER $PID_PATH

    $APP_PATH/script/${APP_NAME}_fastcgi.pl --listen $SOCKET_FILE --pidfile $PID_PATH --nproc $NPROC --daemon 2>>$LOG_FILE

    TIMEOUT=10; while [ ! -r "$PID_PATH" ] && ! kill -0 $(cat "$PID_PATH")
    do
        echo -n '.'; sleep 1; TIMEOUT=$((TIMEOUT - 1))
        if [ $TIMEOUT = 0 ]; then
            echo " ERROR: TIMED OUT"; exit 0
        fi
    done
    echo " started."
    ;;

stop)
    echo "Stopping LIVE $APP_NAME: "
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        PID=`cat $PID_PATH`
        echo -n "killing $PID... ";
        kill $PID
        echo " OK."
        rm $SOCKET_FILE;
    else
        echo "LIVE $APP_NAME not running."
    fi
    ;;

restart|force-reload)
    $0 stop
    echo -n "A necessary sleep... "; sleep 2; echo "done."
    $0 start
    ;;

*)
    echo "Usage: $0 { stop | start | restart }"
    exit 1
    ;;
esac
