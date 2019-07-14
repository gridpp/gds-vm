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

