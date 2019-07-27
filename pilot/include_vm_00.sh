##
## Added for SKA/LOFAR
##
cat <<EOF >/etc/cvmfs/config.d/softdrive.nl.conf
CVMFS_SERVER_URL='http://cvmfs01.nikhef.nl/cvmfs/@fqrn@;http://cvmfs-egi.gridpp.rl.ac.uk:8000/cvmfs/@fqrn@'
CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/softdrive.nl.pub
EOF

cat <<EOF >/etc/cvmfs/keys/softdrive.nl.pub
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA481/kCXbrVtLuzcFZ2uO
EmiAKx28qXIkonPwr/gSmqQ8k1zQA7dKK5YZwZSbVwgYqvhvW6i3vKWLGVDj+elH
1u8uumPzzlAJHrS1XoR8rY4xUULjQBvV9HuJxE6OK4ZEZPvQmeGmjXd446c8J5cv
BQFtaonRnrxAbtO+Z0KtzsNOzBNFegu9z+lT7/fxV17Qh10w5IKQjm/v6jPdj1ME
CrG4QW2S9+Y+7YzbRP5QYaE4cl5cBI3Yb048ufgLJMfX3++uqwGM+rqNs/CzHvsW
dO6Jznr9EbzqbIrTsFeUThNmsGPObxOT3VmB0BTTjrZSYjgf8oEE4hdhgNQgh7vs
OwIDAQAB
-----END PUBLIC KEY-----
EOF

cvmfs_config reload
##
## End of added for SKA/LOFAR
##

##
## Make gridpp the default VO
##
if [ "$VO" == "lhcb" -o "$VO" == "" ] ; then
  VO=gridpp
fi

##
## Tell dirac-pilot to use the GridPP per-VO pools
##
export SUBMIT_POOL="Pool_$VO"

##
## Write logs to our webserver
##
export DEPO_BASE_URL='https://depo.gridpp.ac.uk/hosts'

##
## Use the Imperial top-bdii
##
export LCG_GFAL_INFOSYS="topbdii.grid.hep.ph.ic.ac.uk:2170"

##
## Update singularity if installed (CernVM4)
##
if [ -x /usr/bin/singularity ] ; then

(
rpm -e --nodeps singularity singularity-runtime
# Tell yum to use the current Squid proxy used by cvmfs
export http_proxy=`attr -qg proxy /mnt/.ro`
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install singularity
)

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
