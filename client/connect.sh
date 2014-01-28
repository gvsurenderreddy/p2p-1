#!/bin/bash -e

### make sure that vncviewer is installed
if ! which vncviewer >/dev/null
then
    echo "
You need to install vncviewer:
    sudo apt-get install vncviewer
"
    exit 1
fi

### go to the script directory
cd $(dirname $0)

### get the server from config
. ./config

### get the connection number
echo "(enter the connection number of the remote desktop)"
read -p "CONNECTION NUMBER: " conn

### get the private key of the connection
key=$(tempfile)
echo -e "$conn\n" | ssh -p $port -i keys/get.key vnc@$server > $key 2>/dev/null

### start the tunnel for port-forwarding
ssh -p $port -f -N -t -L 5900:localhost:$conn -i $key vnc@$server 2>/dev/null

### start vncviewer
vncviewer -encodings "copyrect tight zrle hextile" localhost:0