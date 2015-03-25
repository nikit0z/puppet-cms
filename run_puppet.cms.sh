#!/bin/bash -x

ENVIRONMENT=${ENVIRONMENT:-blabla}
WORKSPACE=/data/puppet.cms

# Enable agent and remove lockfile
puppet agent --enable
# Run agent puppetmasterless
rm -f /var/log/puppet-cms.log
puppet apply \
 -t -v --logdest /var/log/puppet-cms.log \
 --environment ${ENVIRONMENT} \
 --modulepath=${WORKSPACE}/modules \
 --hiera_config=${WORKSPACE}/hiera.yaml \
${WORKSPACE}/modules/cms/examples/site.pp

RES=$?

[ $RES -eq 0 ] || [ $RES -eq 2 ] && exit 0

exit 1
