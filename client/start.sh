#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the config
. ./config

### make sure that x11vnc is installed
if ! which x11vnc >$log
then
    echo "
You need to install x11vnc:
    sudo apt-get install x11vnc
"
    exit 1
fi

### create a key pair for the connection and get the private key
key=$(tempfile)
echo -e "\n\n" | ssh -p $port -i keys/create.key vnc@$server > $key 2>>$log
conn=$(sed -n -e '1p' $key)

### start the tunnel for port-forwarding
ssh -p $port -f -N -t -R $conn:localhost:5900 -i $key vnc@$server 2>>$log

### start x11vnc
x11vnc -bg -rfbport 5900 -localhost -nopw -q >>$log 2>&1

### output the connection number
echo "
CONNECTION NUMBER: $conn

(give it to the remote part in order to access your desktop)
"
