#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the config
. ./ssh.rc

### get the required arguments
if [ $# -lt 2 ]
then
    echo "Usage: $0 <local_port> <connection_number>"
    exit 1
fi
local_port=$1
remote_port=$2

### get the private key of the connection
keyfile=$(tempfile)
echo -e "$remote_port\n" | ssh -p $p2p_port -i keys/get.key vnc@$p2p_server > $keyfile 2>>$logfile

### start the tunnel for port-forwarding
ssh="ssh -p $p2p_port -f -N -t"
if [ $compress = 'yes' ]; then ssh="$ssh -C"; fi
$ssh -L $local_port:localhost:$remote_port \
     -i $keyfile vnc@$p2p_server 2>>$logfile
rm $keyfile