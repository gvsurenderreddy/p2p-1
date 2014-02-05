#!/bin/bash -e

function usage {
    echo "
Usage: $0 [OPTIONS] [<key>]

Connect to the remote VNC port and start vncviewer.
The options from command line override the settings
on the config file 'vnc.rc'.

    --help             display this help screen
    --vnc_port=<port>  set the VNC port (5900)
"
    exit 0
}

### go to the script directory
cd $(dirname $0)

### get the config
. ./vnc.rc

### make sure that vncviewer is installed
if ! which vncviewer >$logfile
then
    echo "
You need to install vncviewer:
    sudo apt-get install vncviewer
"
    exit 1
fi

### get the options from command line
for opt in "$@"
do
    case $opt in
	-h|--help)     usage ;;
	--vnc_port=*)  vnc_port=${opt#*=} ;;
	*)             
	    if [ ${opt:0:1} = '-' ]; then usage; fi
	    key=$opt
	    ;;
    esac
done

### get the key name
if [ "$key" = '' ]
then
    echo "Enter the key of the remote desktop."
    read -p "KEY: " key
fi

### connect to the remote VNC port
./port_connect.sh $vnc_port $key

### start vncviewer
disp_nr=$(($vnc_port - 5900))
vncviewer -encodings "copyrect tight zrle hextile" localhost:$disp_nr >>$logfile 2>&1