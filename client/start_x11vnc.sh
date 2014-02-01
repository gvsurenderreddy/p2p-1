#!/bin/bash -e

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

### share the vnc port and get the connection number
read connection_number < <(./port_share.sh $vnc_port)

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

### output the connection number
echo "
CONNECTION NUMBER: $connection_number

Give it to the remote part in order to access your desktop.
To stop the connection run: ./stop.sh $connection_number
"
