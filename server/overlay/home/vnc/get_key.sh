#!/bin/bash
### return the key for a connection
read -p "Enter connection number: " port
cat /home/vnc/keys/$port
