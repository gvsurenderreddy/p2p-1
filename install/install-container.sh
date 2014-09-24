#!/bin/bash -x
### Install and config the system inside a docker container.

### read the options
options=$1
set -a
source $options
set +a

### update /etc/apt/sources.list
cat << EOF > /etc/apt/sources.list
deb $apt_mirror $suite main restricted universe multiverse
deb $apt_mirror $suite-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu $suite-security main restricted universe multiverse
EOF

### run the script for installing the system
export DEBIAN_FRONTEND=noninteractive
$code_dir/install/install-and-config.sh

### fix the configuration of mini-httpd
### when it runs inside a container
### the correct setting should be 'nochroot'
sed -i /etc/mini-httpd.conf \
    -e 's/^chroot/nochroot'