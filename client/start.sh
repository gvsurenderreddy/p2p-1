#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the server from config
. ./config

### create a key pair for the connection and get the private key
key=$(tempfile)
echo -e "\n\n" | ssh -p 2201 -i create.key vnc@$server > $key 2>/dev/null
port=$(sed -n -e '1p' $key)

### start the tunnel for port-forwarding
ssh -p 2201 -f -N -t -R $port:localhost:5900 -i $key vnc@$server 2>/dev/null

### start x11vnc
x11vnc -bg -rfbport 5900 -localhost -nopw -q >/dev/null 2>&1

### output the connection number
echo "
CONNECTION NUMBER: $port

(give it to the remote part in order to access your desktop)
"
