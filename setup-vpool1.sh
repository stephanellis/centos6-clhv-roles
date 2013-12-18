#!/bin/bash

if false
    then
ansible abmx-ffio -a "mkfs.xfs -i size=512 /dev/gback/vpool1b1 -f"
ansible abmx-ffio -a "mkfs.xfs -i size=512 /dev/gback/vpool1b2 -f"
ansible abmx-ffio -a "mkdir -p /exports/vpool1b1"
ansible abmx-ffio -a "mkdir -p /exports/vpool1b2"
ansible abmx-ffio -m shell -a "echo /dev/gback/vpool1b1 /exports/vpool1b1 xfs rw,noatime,nodiratime 0 0 >> /etc/fstab"
ansible abmx-ffio -m shell -a "echo /dev/gback/vpool1b2 /exports/vpool1b2 xfs rw,noatime,nodiratime 0 0 >> /etc/fstab"
ansible abmx-ffio -a "mount /exports/vpool1b1"
ansible abmx-ffio -a "mount /exports/vpool1b2"
ansible abmx-ffio -a "mkdir -p /exports/vpool1b1/b"
ansible abmx-ffio -a "mkdir -p /exports/vpool1b2/b"

ansible hyper121 -a "gluster peer probe 172.16.17.122"
ansible hyper121 -a "gluster peer probe 172.16.17.123"
ansible hyper122 -a "gluster peer detach 172.16.16.10"
ansible hyper122 -a "gluster peer probe 172.16.17.121"

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
ansible hyper121 -a "gluster volume start vpool1"
fi

ansible abmx-ffio -m copy -a src=extra/vol1.xml dest=/tmp/