#!/bin/bash
mkfs -t ext4 /dev/sdb1 &&
mkfs -t ext4 /dev/sdc1 &&
mkfs -t ext4 /dev/sdd1 &&
mkfs -t ext4 /dev/sde1 &&
mkfs -t ext4 /dev/sdf1 &&
mkfs -t ext4 /dev/sdg1 &&
mkfs -t ext4 /dev/sdh1 &&

mount -t ext4 /dev/sdb1 /disk1 &&
mount -t ext4 /dev/sdc1 /disk2 &&
mount -t ext4 /dev/sdd1 /disk3 &&
mount -t ext4 /dev/sde1 /disk4 &&
mount -t ext4 /dev/sdf1 /disk5 &&
mount -t ext4 /dev/sdg1 /disk6 &&
mount -t ext4 /dev/sdh1 /disk7 &&

echo -e "/dev/sdb1                                  /disk1          ext4    defaults        0       0\n/dev/sdc1                                  /disk2          ext4    defaults        0       0\n/dev/sdd1                                  /disk3          ext4    defaults        0       0\n/dev/sde1                                  /disk4          ext4    defaults        0       0\n/dev/sdf1                                  /disk5          ext4    defaults        0       0\n/dev/sdg1                                  /disk6          ext4    defaults        0       0\n/dev/sdh1                                  /disk7          ext4    defaults        0       0" >> /etc/fstab

