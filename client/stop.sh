#!/bin/bash

### go to the script directory
cd $(dirname $0)

### get the config
. ./config

### get the connection number
read -p "CONNECTION NUMBER: " conn

### delete the corresponding keys on the server
echo -e "$conn\n" | ssh -p $port -i keys/delete.key vnc@$server 2>$log

### kill processes
kill -9 $(ps ax | grep "$conn:localhost:" | sed -e 's/^ \+//' | cut -d' ' -f1) 2>>$log
kill -9 $(ps ax | grep ":localhost:$conn" | sed -e 's/^ \+//' | cut -d' ' -f1) 2>>$log
pkill -x x11vnc
pkill -x vncviewer
