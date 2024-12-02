#!/bin/busybox sh

# Mount the /dev, /proc and /sys filesystems.
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

# Rescue shell
exec sh

# Clean up.
umount /dev
umount /proc
umount /sys

# Boot the real thing.
exec switch_root /mnt/root /sbin/init
