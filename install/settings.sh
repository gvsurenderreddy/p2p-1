
### Default settings for building the chroot.
target='P2P'
arch='i386'
suite='trusty'
apt_mirror='http://archive.ubuntu.com/ubuntu'

### Git branch that will be used.
git_branch='master'

### Ports of sshd and httpd.
sshd_port=2201
httpd_port=800

### Start chroot service automatically on reboot.
start_on_boot='false'

### A reboot is needed after installation/configuration.
### If you want to do it automatically, set it to 'true'.
reboot='false'
