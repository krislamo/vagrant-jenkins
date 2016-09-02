# Jenkins

This Vagrant project will provision a VirtualBox machine with Jenkins.
The intended use cases are

  - development on the `ebrc_jenkins` Puppet module
  - a playground for Jenkins job configuration before unleashing to production
    - including pre-flighting Jenkins upgrades
  - a sandbox for Jenkins plugin development

Only the master Jenkins server is provisioned at this time. Provisioning
a separate worker node has not been implemented. Of course the master
server can also serve as a worker so this single node will be sufficient
for most use cases.

Prerequisites
=====

The host computer needs the following.

Vagrant
---------------

Vagrant manages the lifecycle of the virtual machine, following by the instructions in the `Vagrantfile` that is included with this project.

[https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

You should refer to Vagrant documentation and related online forums for information not covered in this document.

VirtualBox
------------------

Vagrant needs VirtualBox to host the virtual machine defined in this project's `Vagrantfile`. Other virtualization software (e.g. VMWare) are not compatible with this Vagrant project as it is currently configured.

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

You should refer to VirtualBox documentation and related online forums for information not covered in this document.

Vagrant Librarian Puppet Plugin
--------------------------------------

This plugin downloads the Puppet module dependencies. Install the plugin with the command

    vagrant plugin install vagrant-librarian-puppet

Vagrant Landrush Plugin (Optional)
--------------------------------------

The [Landrush](https://github.com/phinze/landrush) plugin for Vagrant
provides a local DNS where guest hostnames are registered. This permits,
for example, the `rs1` guest to contact the iCAT enabled server by its
`ies.vm` hostname - a requirement for iRODS installation and function.
This plugin is not strictly required but it makes life easier than
editing `/etc/hosts` files. This plugin has maximum benefit for OS X
hosts, some benefit for Linux hosts and no benefit for Windows. Windows
hosts will need to edit the `hosts` file.

EBRC uses a custom fork of Landrush. In an OS X terminal, run the
following.

    git clone https://github.com/mheiges/landrush.git
    cd landrush
    rake build
    vagrant plugin install pkg/landrush-0.18.0.gem

_If you have trouble getting the host to resolve guest hostnames through landrush try clearing the host DNS cache by running_

`sudo killall -HUP mDNSResponder`.

You should refer to Landrush and Vagrant documentation and related online forums for information not covered in this document.

Usage
=======

    git clone git@github.com:EuPathDB/vagrant-jenkins.git

    cd vagrant-jenkins

    vagrant up

The default Jenkins website will be available at

    http://ci.jenkins.vm:9191/

Setup and Configuration
=======

For most use cases no configuration is needed.

Jenkins is provisioned using Puppet using adjustable parameters defined
in the Hiera file `puppet/environments/production/hieradata/common.xml`

The configuration changes you may be interested in include the Jenkins
version and network ports that the server listens on. These are defined
in the `ebrc_jenkins::instances` Hiera hash.

The most important Puppet module in play here is `ebrc_jenkins` so see
that module's documentation at
https://github.com/EuPathDB/puppet-ebrc_jenkins for details.


`ebrc_jenkins` Puppet module development
=======

A primary use case for this project is for development on the
[`ebrc_jenkins`](https://github.com/EuPathDB/puppet-ebrc_jenkins) Puppet
module. Before editing code in `puppet/modules/ebrc_jenkins` be aware of
how Vagrant is managing all the puppet requirements.

This project uses the Vagrant `vagrant-librarian-puppet` plugin to
manage module dependencies.  Librarian's default behavior is to delete
and repopulate the `puppet/modules` directory. Obviously puts
uncommitted `ebrc_jenkins` module code at risk. To temporarily disable
this default behavior, `touch nolibrarian` in the same directory as the
`Vagrantfile`. With this file in place, librarian will not remove your
uncommitted code. Remove the `nolibrarian` file to restore the behavior
(just be sure to `git commit` first).

Note that librarian clones a specific git commit of `ebrc_jenkins` that
is detached from HEAD. You should correct this before developing on the
module so you will be able to commit your changes.

When restoring librarian, you typically will need to remove
`Puppetfile.lock` so it will be regenerated with the latest commit
version of `ebrc_jenkins`.

Manual Puppet Run
=======

When doing `ebrc_jenkins` Puppet module development you can trigger a
run of the puppet agent with `vagrant provision` on the Vagrant host or
by running the puppet agent on the guest.

    sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/site.pp
