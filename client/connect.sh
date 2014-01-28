#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the server from config
. ./config

### get the connection number
echo "(enter the connection number of the remote desktop)"
read -p "CONNECTION NUMBER: " port

### get the private key of the connection
key=$(tempfile)
echo -e "$port\n" | ssh -p 2201 -i get.key vnc@$server > $key 2>/dev/null

### start the tunnel for port-forwarding
ssh -p 2201 -f -N -t -L 5900:localhost:$port -i $key vnc@$server 2>/dev/null

### start vncviewer
vncviewer -encodings "copyrect tight zrle hextile" localhost:0