#!/bin/bash

CHROOT=/var/chroot/p2p

CHROOT_SERVICES="ssh mini-httpd"
MOUNT_POINTS="proc dev sys dev/pts"

### reverse a list of words given as parameter
function reverse {
    list_of_words=$1
    reversed_list=''
    for word in $list_of_words
    do
	reversed_list="$word $reversed_list"
    done
    echo $reversed_list
}

case "$1" in
    start)
	# mount /proc etc. to the CHROOT
	for DIR in $MOUNT_POINTS
	do
	    mount -o bind /$DIR $CHROOT/$DIR
	done
	chroot $CHROOT/ mount -a

	# start the services inside the CHROOT
	for service in $CHROOT_SERVICES
	do
	    chroot $CHROOT/ /etc/init.d/$service start
	done

	# start cron
	chroot $CHROOT/ cron

        ### update the list of the authorized keys
        chroot $CHROOT/ /home/vnc/update_keys.sh
	;;

    stop)
	# stop cron
	chroot $CHROOT/ killall cron

	# stop the services inside the CHROOT
	for service in $(reverse "$CHROOT_SERVICES")
	do
	    chroot $CHROOT/ /etc/init.d/$service stop
	done

        # kill any remaining processes that are still running on CHROOT
        chroot_pids=$(for p in /proc/*/root; do ls -l $p; done | grep $CHROOT | cut -d'/' -f3)
	test -z "$chroot_pids" || (kill -9 $chroot_pids; sleep 2)

	chroot $CHROOT/ umount -a

	# umount /proc etc. from the CHROOT
	for DIR in $(reverse "$MOUNT_POINTS")
	do
	    umount $CHROOT/$DIR
	done
	;;
    *)
	echo " * Usage: $0 {start|stop}"
esac
