CentOS 6 Roles
==============

Ansible roles for CentOS (maybe RHEL) 6. The main goal is to
provide best practices configuration for clusters of hypervisors
on CentOS using GlusterFS for shared/nothing storage. It also
includes roles that configure infiniband hardware for use as
the interconnect for glusterfs.

Check out lab.yml for an example playbook that is the actual
playbook I use on my lab environment.

hosts-lab.ini is the actual inventory file I use for this lab
playbook.

Roles
-----
base-centos6 - installs admin tools that I use on most installations  
hypervisor - installs and configures libvirt and kvm  
clusternode - installs High Availability group and configures a basic cluster to manage highly available kvm quests  
glusterfs-server - installs and configures server components for glusterfs  
glusterfs-client - installs and configures client components of glusterfs  
infiniband-host - installs and configures infiniband host components, optimized for IPoIB  
infiniband-ringmember - assembles an IPoIB network in a ring topology using OSPF to manage routes.  Also sets up loopback addresses for use as endpoint addresses for gluster bricks, etc..  

### extras directory
includes scripts and snippets for setting up my lab environment, specifically the gluster bricks and volumes, as well as the storage pools for the hypervisors in my lab


Notes
-----

### tags
repos - installs yum repo definitions and keys  
packages - installs packages  
services - starts and enables services  
configs - configurations files  
firewall - firewall configuration  
iptables - IPv4 firewall stuff  
ip6tables - IPv6 firewall stuff, not implemented yet :(  
directories - creates directories for various  

### GlusterFS Volume Options for VMs
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

### clusternode role
takes parameters thusly:
- {role: clusternode, cluster_group: clusternodes, apcpdu_group: apcspuds}

if apcpdu_group is passed in, cluster.conf will be setup with fence_apc_snmp  
if ipmi_ip is available as a hostvar, an ipmi fence device and method will be defined in the cluster.conf for the host  

