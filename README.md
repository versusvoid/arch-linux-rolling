arch-linux-rolling
=

Kernel for archlinux the way it meant to be.

With the expense of additional packaging and unpackaging and without [infamous bug](https://bugs.archlinux.org/task/16702).

## installation

The simplest approach would be:
```bash
$ sudo pacman -U linux-rolling-transitional-4.13.9-1-x86_64.pkg.tar \
    linux-rolling_4_13_9_1-4.13.9-1-x86_64.pkg.tar
```

Note, if you installed `linux-rolling-transitional` after `linux-rolling_*`, you should manually regenerate `grub.cfg`.
