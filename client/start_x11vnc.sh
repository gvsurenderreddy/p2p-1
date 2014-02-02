#!/bin/bash -e

function usage {
    echo "
Usage: $0 [OPTIONS]

Share the VNC port and start an x11vnc server.
The options from command line override the settings
on the config file 'vnc.rc'.

    --help             display this help screen
    --vnc_port=<port>  set the VNC port (5900)
    --window=yes       share a single window, not the whole desktop
    --viewonly=yes     the desktop cannot be controlled remotely
    --shared=yes       more than one computer can connect at the same time
    --forever=yes      keep listening for more connections (don't exit
                       when the first client(s) disconnect)
"
    exit 0
}

### go to the script directory
cd $(dirname $0)

### get the config
. ./vnc.rc

### make sure that x11vnc is installed
if ! which x11vnc >$logfile
then
    echo "
You need to install x11vnc:
    sudo apt-get install x11vnc
"
    exit 1
fi

### get the options from command line
for opt in "$@"
do
    case $opt in
	-h|--help)     usage ;;
	--vnc_port=*)  vnc_port=${opt#*=} ;;
	--window=*)    window=${opt#*=} ;;
	--viewonly=*)  viewonly=${opt#*=} ;;
	--shared=*)    shared=${opt#*=} ;;
	--forever=*)   forever=${opt#*=} ;;
	*)             if [ ${opt:0:1} = '-' ]; then usage; fi ;;
    esac
done

### share the vnc port and get the key name
read key < <(./port_share.sh $vnc_port)

### start x11vnc
x11vnc="x11vnc -bg -nopw -q"
if [ $window = 'yes' ]
then
    echo "Select with mouse the window that is to be shared."
    x11vnc="$x11vnc -sid pick"
fi
if [ $viewonly = 'yes' ]; then x11vnc="$x11vnc -viewonly"; fi
if [ $shared = 'yes' ]; then x11vnc="$x11vnc -shared"; fi
if [ $forever = 'yes' ]; then x11vnc="$x11vnc -forever"; fi
$x11vnc -rfbport $vnc_port -localhost >>$logfile 2>&1

### output the key name
echo "
KEY: $key

Give it to the remote part in order to access your desktop.
To stop the connection run: $(dirname $0)/stop.sh $key
"
