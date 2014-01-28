#!/bin/bash

cd /home/vnc/

### delete keys older than 1 day
find keys/ -mtime +1 -exec rm {} \;

### update authorized_keys
cat special_keys/*.pub keys/*.pub > .ssh/authorized_keys 2> /dev/null
