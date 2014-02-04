#!/bin/bash

### get the port
port=$1
if [ "$port" = '' ]
then
    old_port=$(cat /home/vnc/www/port)
    read -p "Enter new sshd port [$old_port]: " new_port
    port=${new_port:-$old_port}
fi

### change the port
sed -i /etc/ssh/sshd_config -e "/^Port/c Port $port"

### restart the service
service ssh restart

### update www data
### if mini-httpd is running, clients can get the port from it
echo $port > /home/vnc/www/port
sed -i /home/vnc/www/index.html \
    -e "s#<strong>port=[0-9]\+</strong>#<strong>port=$port</strong>#"

### notify
echo "
SSH port changed to $port.
You should notify all the clients about this change,
otherwise they will not be able to use this service.
"
