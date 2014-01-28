#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the config
. ./config

### make sure that vncviewer is installed
if ! which vncviewer >$log
then
    echo "
You need to install vncviewer:
    sudo apt-get install vncviewer
"
    exit 1
fi

### get the connection number
echo "(enter the connection number of the remote desktop)"
read -p "CONNECTION NUMBER: " conn

### get the private key of the connection
key=$(tempfile)
echo -e "$conn\n" | ssh -p $port -i keys/get.key vnc@$server > $key 2>>$log

### start the tunnel for port-forwarding
ssh -p $port -f -N -t -L 5900:localhost:$conn -i $key vnc@$server 2>>$log

### start vncviewer
vncviewer -encodings "copyrect tight zrle hextile" localhost:0 >>$log 2>&1