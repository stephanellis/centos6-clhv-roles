playbooks
=========

Ansible roles and playbooks for CentOS. The main goal is to
provide best practices configuration for clusters of hypervisors
on CentOS using GlusterFS for shared/nothing storage. It also
includes roles that configure infiniband hardware for use as
the interconnect for glusterfs.

Check out lab.yml for an example playbook that is the actual
playbook I use on my lab environment.

hosts-lab.ini is the actual inventory file I use for this lab
playbook.

Notes
=====

tags
----

repos - installs yum repo definitions and keys
packages - installs packages
services - starts and enables services
configs - configurations files
firewall - firewall configuration
directories - creates directories for various

GlusterFS Volume Options for VMs
-------------------------

After you create a gluster volume and before you start it, these options should be set
to optimize the volume for vm disk images.

[See this page from RedHat](https://access.redhat.com/site/documentation/en-US/Red_Hat_Storage/2.0/html/Quick_Start_Guide/chap-Quick_Start_Guide-Virtual_Preparation.html#tuning_for_virt)

gluster volume set vpool1 performance.quick-read off

gluster volume set vpool1 performance.read-ahead off

gluster volume set vpool1 performance.io-cache off

gluster volume set vpool1 performance.stat-prefetch off

gluster volume set vpool1 cluster.eager-lock enable

gluster volume set vpool1 network.remote-dio on

gluster volume set vpool1 storage.owner-uid 107

gluster volume set vpool1 storage.owner-gid 107

