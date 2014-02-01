#!/bin/bash -e

function usage {
    echo "
Usage: $0 [OPTIONS] <local_port>

Share a local port through a ssh tunnel.
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
            local_port=$opt
            ;;
    esac
done

### check the presence of the required arguments
if [ "$local_port" = '' ]
then
    echo -e "\nError: Required argument <local_port> is missing."
    usage
fi

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
