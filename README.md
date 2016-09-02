
Only the master Jenkins server is provisioned at this time. Provisioning
a separate worker node has not been implemented. Of course the master
server can also serve as a worker so this single node will be sufficient
for most use cases.

Manual Puppet Run
=======

    sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/site.pp
