#!/bin/bash

### go to the script directory
cd $(dirname $0)

### get the required argument
if [ "$1" = '' ]
then
    echo "Usage: $0 <connection_number>"
    exit 1
fi
remote_port=$1

### get the config
. ./ssh.rc

### delete the corresponding keys on the server
echo -e "$remote_port\n" | ssh -p $p2p_port -i keys/delete.key vnc@$p2p_server 2>$logfile

### kill ssh tunnels
pid1=$(ps ax | grep "$remote_port:[lL]ocalhost:" | sed -e 's/^ \+//' | cut -d' ' -f1)
pid2=$(ps ax | grep ":[lL]ocalhost:$remote_port" | sed -e 's/^ \+//' | cut -d' ' -f1)
kill -9 $pid1 $pid2
