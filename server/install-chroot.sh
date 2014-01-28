#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

### upgrade and install other needed packages
apt-get update
apt-get -y upgrade
install='apt-get -y -o DPkg::Options::=--force-confdef -o DPkg::Options::=--force-confold install'
$install openssh-server aptitude vim nano language-pack-en netcat cron
#$install gawk unzip wget curl diff git

### generates the file /etc/defaults/locale
update-locale

### create a user 'vnc'
useradd --system --create-home vnc

### copy overlay files over to the system
dir=$(dirname $0)
cp -TdR $dir/overlay/ /

### set correct permissions
chown vnc:vnc -R /home/vnc/
chmod 700 /home/vnc/.ssh
