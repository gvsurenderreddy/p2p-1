#!/bin/bash

### get a random port number between 1025-65535
### check to make sure that it is not already used
port=$(shuf -i 1025-65535 -n 1)
while netcat -zv 127.0.0.1 $port <<<'' &> /dev/null
do
    port=$(shuf -i 1025-65535 -n 1)
done

### generate the key pair
file=keys/$port
echo -e "$file\n\n\n" | ssh-keygen -t rsa > /dev/null 2>&1

### put some restrictions on the public key
### and append it to authorized_keys
restrictions='command="/bin/sleep 4294967295",no-agent-forwarding,no-user-rc,no-X11-forwarding,permitopen="localhost:'$port'" '
sed -e "s#^#$restrictions#" -i $file.pub
cat $file.pub >> /home/vnc/.ssh/authorized_keys

### output the port and the private key
echo $port
cat $file
