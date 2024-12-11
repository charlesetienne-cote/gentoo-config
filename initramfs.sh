#!/bin/busybox sh

# Mount the /dev, /proc and /sys filesystems.
mount -nt devtmpfs none /dev
mount -nt proc none /proc
mount -nt sysfs none /sys
mount -nt tmpfs none /run

# Rescue shell
exec /bin/busybox sh

mount -nt btrfs -o noacl,autodefrag,compress-force=zstd,datacow,datasum,disc
ard=async,space_cache=v2,ssd_spread,noatime,rw,suid,dev,exec,async /dev/mapper/C
ryptRoot /mnt/root

umount /run
umount /sys
umount /proc
umount /dev

exec switch_root /mnt/root /sbin/init
