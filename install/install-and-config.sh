#!/bin/bash -x

### upgrade and install other needed packages
apt-get update
apt-get -y upgrade
apt-get -y install psmisc openssh-server netcat cron mini-httpd supervisor git
initctl reload-configuration

### create a run dir for sshd
mkdir /var/run/sshd
chmod 755 /var/run/sshd

### generates the file /etc/defaults/locale
#apt-get -y install language-pack-en
#update-locale

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
/home/vnc/change_sshd_port.sh $sshd_port

### customize the configuration of sshd
sed -i /etc/ssh/sshd_config \
    -e 's/^Port/#Port/' \
    -e 's/^PermitRootLogin/#PermitRootLogin/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/' \
    -e 's/^UseLogin/#UseLogin/' \
    -e 's/^AllowUsers/#AllowUsers/' \
    -e 's/^Banner/#Banner/'

sed -i /etc/ssh/sshd_config \
    -e '/^### p2p config/,$ d'

cat <<EOF >> /etc/ssh/sshd_config
### p2p config
Port $sshd_port
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
UseLogin no
AllowUsers vnc
Banner /etc/issue
EOF

### customize the configuration of mini-httpd
sed -i /etc/mini-httpd.conf \
    -e 's/^host/#host/' \
    -e 's/^port/#port/' \
    -e 's/^chroot/#chroot/' \
    -e 's/^nochroot/#nochroot/' \
    -e 's/^data_dir/#data_dir/' \

sed -i /etc/mini-httpd.conf \
    -e '/^### p2p config/,$ d'

cat <<EOF >> /etc/mini-httpd.conf
### p2p config
host=0.0.0.0
port=$httpd_port
chroot
data_dir=/home/vnc/www
EOF

sed -i /etc/default/mini-httpd \
    -e '/^START/ c START=1'

### customize the shell prompt
echo $target > /etc/debian_chroot
sed -i /root/.bashrc \
    -e '/^#force_color_prompt=/c force_color_prompt=yes' \
    -e '/^# get the git branch/,+4 d'
cat <<EOF >> /root/.bashrc
# get the git branch (used in the prompt below)
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
EOF
PS1='\\n\\[\\033[01;32m\\]${debian_chroot:+($debian_chroot)}\\[\\033[00m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\e[32m\\]$(parse_git_branch)\\n==> \\$ \\[\\033[00m\\]'
sed -i /root/.bashrc \
    -e "/^if \[ \"\$color_prompt\" = yes \]/,+2 s/PS1=.*/PS1='$PS1'/"
