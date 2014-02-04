#!/bin/bash

### get the new port
read -p 'Enter new sshd port: ' port

### change the port
sed -i /etc/ssh/sshd_config -e "/^Port/c Port $port"

### restart the service
service ssh restart

### notify
echo "
SSH port changed to $port.
You should notify all the clients about this change,
otherwise they will not be able to use this service.
"

### update www data
### if mini-httpd is running, clients can get the port from it
cat $port > /home/vnc/www/port
set -i /home/vnc/www/index.html \
    -e "s#<strong>port=\d+</strong>#<strong>port=$port</strong>#"