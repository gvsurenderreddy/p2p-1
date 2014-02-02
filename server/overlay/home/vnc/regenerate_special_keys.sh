#!/bin/bash

### directory of the special keys
dir=/home/vnc/special_keys

### regenerate the keys
for key in create delete get
do
    file=$dir/$key
    echo -e "$file\n\n\n" | ssh-keygen -t rsa > /dev/null 2>&1
    mv $file $file.key

    ### put restrictions on the public key
    restrictions='command="/home/vnc/'$key'_key.sh",no-agent-forwarding,no-user-rc,no-X11-forwarding'
    sed -e "s#^#$restrictions #" -i $file.pub
done

### copy keys to www/keys/
cp $dir/*.key /home/vnc/www/keys/
chmod +r /home/vnc/www/keys/*.key

### update authorized keys
/home/vnc/update_keys.sh

### notify
echo "
New keys were generated.
You should notify all the clients to get the new keys,
otherwise they will not be able to connect.
"
