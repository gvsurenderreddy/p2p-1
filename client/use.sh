#!/bin/bash
### set the p2p_server to be used

### go to the script directory
cd $(dirname $0)

### include config file
. ./ssh.rc

### get the arguments
if [ "$1" = '' ]
then
    echo "
Usage: $0 <p2p_server> [<http_port>]

Set the IP or DN of the P2P server to be used.
<http_port> is the port of the webserver from
where the p2p port and keys are retrieved.

Examples:
    $0 p2p.example.org
    $0 173.194.39.104 8000
"
    exit 1
fi
p2p_server=$1
http_port=${2:-800}

### url of the webserver
webserver="http://$p2p_server:$http_port"

### get the p2p port from the webserver
p2p_port=$(wget $webserver/port -O- 2>$logfile)

### update ssh.rc
sed -i ssh.rc \
    -e "/^p2p_server/c p2p_server=$p2p_server" \
    -e "/^p2p_port/c p2p_port=$p2p_port"

### get the keys from the webserver
for keyname in create delete get
do
    wget -O keys/$keyname.key $webserver/keys/$keyname.key >> $logfile 2>&1
done

### set proper permissions to the keys
chmod 600 keys/*.key