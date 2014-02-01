#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the config
. ./vnc.rc

### make sure that vncviewer is installed
if ! which vncviewer >$logfile
then
    echo "
You need to install vncviewer:
    sudo apt-get install vncviewer
"
    exit 1
fi

### get the connection number
echo "Enter the connection number of the remote desktop."
read -p "CONNECTION NUMBER: " connection_number

### connect to the remote VNC port
./port_connect.sh $vnc_port $connection_number

### start vncviewer
vncviewer -encodings "copyrect tight zrle hextile" localhost:0 >>$logfile 2>&1