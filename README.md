playbooks
=========

Ansible Playbooks for CentOS

check out labcluster.yml for an example

tags
----

repos - installs yum repo definitions and keys

packages - installs packages

services - starts and enables services

configs - configurations files

firewall - firewall configuration



GlusterFS Volume Options for VMs
-------------------------

gluster volume set vpool1 performance.quick-read off
gluster volume set vpool1 performance.read-ahead off
gluster volume set vpool1 performance.io-cache off
gluster volume set vpool1 performance.stat-prefetch off
gluster volume set vpool1 cluster.eager-lock enable
gluster volume set vpool1 network.remote-dio on

gluster volume set vpool1 storage.owner-uid 107
gluster volume set vpool1 storage.owner-gid 107

