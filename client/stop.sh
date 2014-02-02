#!/bin/bash
### this is used for both x11vnc and vncviewer

### go to the script directory
cd $(dirname $0)

### get the connection number
connection_number=$1
if [ "$connection_number" = '' ]
then
    read -p "CONNECTION NUMBER: " connection_number
fi

### stop sharing the port for this connection
./port_stop.sh $connection_number

### kill processes
pkill -x x11vnc
pkill -x linuxvnc
pkill -x vncviewer
