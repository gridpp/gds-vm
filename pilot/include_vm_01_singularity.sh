if [ -x /usr/bin/singularity ] ; then
##
## Rewrite singularity configuration to match the active lines from a typical WLCG 
## site (Manchester) config, made with
## egrep -v '^#|^$' /etc/singularity/singularity.conf 
##
mv -f /etc/singularity/singularity.conf /etc/singularity/singularity.conf.saved
cat <<EOF >/etc/singularity/singularity.conf
allow setuid = yes
max loop devices = 256
allow pid ns = yes
config passwd = yes
config group = yes
config resolv_conf = yes
mount proc = yes
mount sys = yes
mount dev = yes
mount devpts = yes
mount home = yes
mount tmp = yes
mount hostfs = no
bind path = /etc/localtime
bind path = /etc/hosts
user bind control = yes
enable overlay = no
enable underlay = yes
mount slave = yes
sessiondir max size = 16
allow container squashfs = yes
allow container extfs = yes
allow container dir = yes
memory fs type = tmpfs
always use nv = no
EOF
fi
