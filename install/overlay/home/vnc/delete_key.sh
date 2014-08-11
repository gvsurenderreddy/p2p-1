#!/bin/bash
### remove the keys for a connection

### get the key name
read -p "Enter key: " key

### get the port from the first line of the private key
file=keys/$key
port=$(head 1 $file)

### remove the key from authorized_keys
cd /home/vnc/
sed -e "/localhost:$port/ d" -i .ssh/authorized_keys

### remove the key files
rm $file $file.pub
