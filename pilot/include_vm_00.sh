# Enable config-egi.egi.eu
cat <<EOF >/etc/cvmfs/default.d/60-egi.conf
CVMFS_CONFIG_REPOSITORY=config-egi.egi.eu
EOF

# Apply the CernVM-FS configuration changes
cvmfs_config reload

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

