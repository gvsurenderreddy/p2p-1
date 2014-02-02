#!/bin/bash -e

function usage {
    echo "
Usage: $0 [OPTIONS] <local_port> <key>

Connect a local port to a shared remote port through a ssh tunnel.
The options from command line override the settings
on the config file 'ssh.rc'.

    --help                 display this help screen
    --p2p_server=<server>  IP or DN of the p2p server
    --p2p_port=<port>      port of the sshd service in the p2p server (2201)
    --compress=yes         compress the ssh connections
"
    exit 0
}

### go to the script directory
cd $(dirname $0)

### get the config
. ./ssh.rc

### get the options from command line
for opt in "$@"
do
    case $opt in
	-h|--help)     usage ;;
	--p2p_server=*)  p2p_server=${opt#*=} ;;
	--p2p_port=*)    p2p_port=${opt#*=} ;;
	--compress=*)    compress=${opt#*=} ;;
	*)
            if [ ${opt:0:1} = '-' ]; then usage; fi
            if [ "$local_port" = '' ]
	    then
		local_port=$opt
	    elif [ "$key" = '' ]
            then
		key=$opt
	    else
		usage
            fi
            ;;
    esac
done

### check the presence of the required arguments
if [ "$local_port" = '' ]
then
    echo -e "\nError: Required argument <local_port> is missing."
    usage
fi
if [ "$key" = '' ]
then
    echo -e "\nError: Required argument <key> is missing."
    usage
fi

### get the private key of the connection
keyfile=$(tempfile)
echo -e "$key\n" | ssh -p $p2p_port -i keys/get.key vnc@$p2p_server > $keyfile 2>>$logfile

### get the remote port from the key file
remote_port=$(head -1 $keyfile)

### start the tunnel for port-forwarding
ssh="ssh -p $p2p_port -f -N -t"
if [ $compress = 'yes' ]; then ssh="$ssh -C"; fi
$ssh -L $local_port:localhost:$remote_port \
     -i $keyfile vnc@$p2p_server 2>>$logfile
rm $keyfile