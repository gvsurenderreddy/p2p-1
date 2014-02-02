#!/bin/bash -e
### VNC server to allow remote access to a tty. linuxvnc can export
### your currently running text sessions to any VNC client. It can be
### useful if you want to move to another computer without having to
### log out or to help a distant colleague solve a problem.

function usage {
    echo "
Usage: $0 [OPTIONS]

Share the VNC port and start a linuxvnc server.
The options from command line override the settings
on the config file 'vnc.rc'.

    --help             display this help screen
    --vnc_port=<port>  set the VNC port (5900)
    --tty=2            set the tty number (2-6)
"
    exit 0
}

### go to the script directory
cd $(dirname $0)

### get the config
. ./vnc.rc

### make sure that linuxvnc is installed
if ! which linuxvnc >$logfile
then
    echo "
You need to install linuxvnc:
    sudo apt-get install linuxvnc
"
    exit 1
fi

### get the options from command line
tty=2
for opt in "$@"
do
    case $opt in
	-h|--help)     usage ;;
	--vnc_port=*)  vnc_port=${opt#*=} ;;
	--tty=*)       tty=${opt#*=} ;;
	*)             if [ ${opt:0:1} = '-' ]; then usage; fi ;;
    esac
done

### share the vnc port and get the key name
read key < <(./port_share.sh $vnc_port)
echo "
KEY: $key

Give it to the remote part in order to access your desktop.
To stop the connection run: $(dirname $0)/stop.sh $key
"

### start linuxvnc
sudo linuxvnc $tty -rfbport $vnc_port -localhost >>$logfile 2>&1
