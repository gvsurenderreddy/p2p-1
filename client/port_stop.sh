#!/bin/bash

function usage {
    echo "
Usage: $0 [OPTIONS] <connection_number>

Stop the P2P connection and close the ssh tunnels.
The options from command line override the settings
on the config file 'ssh.rc'.

    --help                 display this help screen
    --p2p_server=<server>  IP or DN of the p2p server
    --p2p_port=<port>      port of the sshd service in the p2p server (2201)
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
	-h|--help)       usage ;;
	--p2p_server=*)  p2p_server=${opt#*=} ;;
	--p2p_port=*)    p2p_port=${opt#*=} ;;
	*)
            if [ ${opt:0:1} = '-' ]; then usage; fi
            remote_port=$opt
            ;;
    esac
done

### check the presence of the required arguments
if [ "$remote_port" = '' ]
then
    echo -e "\nError: Required argument <connection_number> is missing."
    usage
fi

### delete the corresponding keys on the server
echo -e "$remote_port\n" | ssh -p $p2p_port -i keys/delete.key vnc@$p2p_server 2>$logfile

### kill ssh tunnels
pid1=$(ps ax | grep "$remote_port:[lL]ocalhost:" | sed -e 's/^ \+//' | cut -d' ' -f1)
pid2=$(ps ax | grep ":[lL]ocalhost:$remote_port" | sed -e 's/^ \+//' | cut -d' ' -f1)
kill -9 $pid1 $pid2
