#!/bin/bash

### go to the script directory
cd $(dirname $0)

### get the server from config
. ./config

### get the connection number
read -p "CONNECTION NUMBER: " conn

### delete the corresponding keys on the server
echo -e "$conn\n" | ssh -p $port -i keys/delete.key vnc@$server 2>/dev/null

### kill processes
kill -9 $(ps ax | grep ssh | grep $conn | cut -d' ' -f1) 2>/dev/null
pkill -x x11vnc
pkill -x vncviewer
