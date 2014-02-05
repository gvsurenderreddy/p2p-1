#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

### upgrade and install other needed packages
apt-get update
apt-get -y upgrade
install='apt-get -y -o DPkg::Options::=--force-confdef -o DPkg::Options::=--force-confold install'
$install openssh-server netcat cron mini-httpd
initctl reload-configuration

### generates the file /etc/defaults/locale
$install language-pack-en
update-locale

### create a user 'vnc'
useradd --system --create-home vnc

### copy overlay files over to the system
dir=$(dirname $0)
cp -TdR $dir/overlay/ /

### set correct permissions
chown vnc:vnc -R /home/vnc/
chmod 700 /home/vnc/.ssh

### customize the configuration of the chroot system
/home/vnc/regenerate_special_keys.sh
/home/vnc/change_sshd_port.sh 2201
