#!/bin/bash
### this is used for both x11vnc and vncviewer

### go to the script directory
cd $(dirname $0)

### get the connection number
read -p "CONNECTION NUMBER: " conn

### stop sharing the port for this connection
./port_stop.sh $conn

### kill processes
pkill -x x11vnc
pkill -x vncviewer
