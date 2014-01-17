#! /bin/bash

ansible labcluster -a "mkfs.xfs -i size=512 /dev/gback/vpool1b1 -f"
ansible labcluster -a "mkfs.xfs -i size=512 /dev/gback/vpool1b2 -f"
ansible labcluster -a "mkdir -p /exports/vpool1b1"
ansible labcluster -a "mkdir -p /exports/vpool1b2"
ansible labcluster -m shell -a "echo /dev/gback/vpool1b1 /exports/vpool1b1 xfs rw,noatime,nodiratime 0 0 >> /etc/fstab"
ansible labcluster -m shell -a "echo /dev/gback/vpool1b2 /exports/vpool1b2 xfs rw,noatime,nodiratime 0 0 >> /etc/fstab"
ansible labcluster -a "mount /exports/vpool1b1"
ansible labcluster -a "mount /exports/vpool1b2"
ansible labcluster -a "mkdir -p /exports/vpool1b1/b"
ansible labcluster -a "mkdir -p /exports/vpool1b2/b"

ansible hyper121 -a "gluster peer probe 172.16.17.122"
sleep 5
ansible hyper121 -a "gluster peer probe 172.16.17.123"
sleep 5
# fix the address for hyper121 in the trusted storage pool
# side effect of the ring topology
sleep 5

ansible hyper122 -a "gluster peer detach 172.16.16.10"
sleep 5

ansible hyper122 -a "gluster peer probe 172.16.17.121"

sleep 10

ansible hyper121 -a "gluster volume create vpool1 replica 2 transport tcp 172.16.17.121:/exports/vpool1b1/b 172.16.17.122:/exports/vpool1b2/b 172.16.17.122:/exports/vpool1b1/b 172.16.17.123:/exports/vpool1b2/b 172.16.17.123:/exports/vpool1b1/b 172.16.17.121:/exports/vpool1b2/b"

ansible hyper121 -a "gluster volume set vpool1 server.allow-insecure on"
ansible hyper121 -a "gluster volume set vpool1 performance.quick-read off"
ansible hyper121 -a "gluster volume set vpool1 performance.read-ahead off"
ansible hyper121 -a "gluster volume set vpool1 performance.io-cache off"
ansible hyper121 -a "gluster volume set vpool1 performance.stat-prefetch off"
ansible hyper121 -a "gluster volume set vpool1 cluster.eager-lock enable"
ansible hyper121 -a "gluster volume set vpool1 network.remote-dio on"
ansible hyper121 -a "gluster volume set vpool1 storage.owner-uid 107"
ansible hyper121 -a "gluster volume set vpool1 storage.owner-gid 107"
ansible hyper121 -a "gluster volume set vpool1 nfs.disable on"
ansible hyper121 -a "gluster volume start vpool1"

sleep 10

ansible labcluster -m copy -a "src=extras/vpool1.xml dest=/tmp/"
ansible labcluster -a "virsh pool-define /tmp/vpool1.xml"

ansible labcluster -a "mkdir /var/lib/libvirt/images/vpool1"
ansible labcluster -a "virsh pool-start vpool1"
ansible labcluster -a "virsh pool-autostart vpool1"

ansible labcluster -m copy -a "src=extras/iso-sn1.xml dest=/tmp/"
ansible labcluster -a "virsh pool-define /tmp/iso-sn1.xml"

ansible labcluster -a "mkdir /var/lib/libvirt/images/iso-sn1"
ansible labcluster -a "virsh pool-autostart iso-sn1"


# reboot the servers after running this script

