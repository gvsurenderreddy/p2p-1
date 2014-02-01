#!/bin/bash -e

function usage {
    echo "
Usage: $0 [OPTIONS]

Connect to the remote VNC port and start vncviewer.
The options from command line override the settings
on the config file 'vnc.rc'.

    --help             display this help screen
    --vnc_port=<port>  set the VNC port (5900)
    --conn=<conn_nr>   connection number to the remote desktop
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
	--conn=*)      connection_number=${opt#*=} ;;
	*)             if [ ${opt:0:1} = '-' ]; then usage; fi ;;
    esac
done

### get the connection number
if [ "$connection_number" = '' ]
then
    echo "Enter the connection number of the remote desktop."
    read -p "CONNECTION NUMBER: " connection_number
fi

### connect to the remote VNC port
./port_connect.sh $vnc_port $connection_number

### start vncviewer
disp_nr=$(($vnc_port - 5900))
vncviewer -encodings "copyrect tight zrle hextile" localhost:$disp_nr >>$logfile 2>&1