#!/bin/bash
### remove the keys for a connection

read -p "Enter connection number: " port

cd /home/vnc/
sed -e "/localhost:$port/ d" -i .ssh/authorized_keys
rm keys/$port keys/$port.pub
