#!/bin/bash -e

### go to the script directory
cd $(dirname $0)

### get the required argument
if [ "$1" = '' ]
then
    echo "Usage: $0 <local_port>"
    exit 1
fi
local_port=$1

### get the config
. ./ssh.rc

### create a key pair for the connection and get
### the connection number and the private key
keyfile=$(tempfile)
echo -e "\n\n" | ssh -p $p2p_port -i keys/create.key vnc@$p2p_server > $keyfile 2>>$logfile
remote_port=$(sed -n -e '1p' $keyfile)

### start the tunnel for port-forwarding
ssh="ssh -p $p2p_port -f -N -t"
if [ $compress = 'yes' ]; then ssh="$ssh -C"; fi
$ssh -R $remote_port:localhost:$local_port \
     -i $keyfile vnc@$p2p_server 2>>$logfile
rm $keyfile

### output the connection number
echo $remote_port
