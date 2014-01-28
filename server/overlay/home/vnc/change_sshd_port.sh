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
