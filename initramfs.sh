#!/bin/busybox sh

# Mount the /dev, /proc and /sys filesystems.
mount -nt devtmpfs none /dev
mount -nt proc none /proc
mount -nt sysfs none /sys
mount -nt tmpfs none /run

# Rescue shell
exec /bin/busybox sh