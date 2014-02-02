#!/bin/bash
### this is used for both x11vnc and vncviewer

### go to the script directory
cd $(dirname $0)

### get the key name
key=$1
if [ "$key" = '' ]
then
    read -p "KEY: " key
fi

### stop sharing the port
./port_stop.sh $key

### kill processes
pkill -x x11vnc
pkill -x linuxvnc
pkill -x vncviewer
