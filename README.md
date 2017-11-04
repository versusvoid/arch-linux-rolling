arch-linux-rolling
=

Kernel for archlinux the way it meant to be.

With the expense of additional packaging and unpackaging and without [infamous bug](https://bugs.archlinux.org/task/16702).

## installation

Note, if you installed `linux-rolling` after `linux-rolling_*`, you should manually regenerate `grub.cfg`.

## Boot loader configuration

`91-grub.hook` will update default grub install (in `/boot` directory with config at `/boot/grub/grub.cfg`)
automatically.

`systemd-boot` and `syslinux` both use manual configuration, so there is no easy universal update
mechanism.
