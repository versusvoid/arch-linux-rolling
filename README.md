arch-linux-rolling
=

Kernel for archlinux the way it meant to be.

With the expense of additional packaging and unpackaging and without [infamous bug](https://bugs.archlinux.org/task/16702).

## installation

There is a quirk with installation. The simplest approach would be:
```bash
$ sudo pacman -U linux-rolling-transitional-4.13.9-1-x86_64.pkg.tar \
    linux-rolling_4_13_9_1-4.13.9-1-x86_64.pkg.tar
```
this will replace existing `linux` package.

`linux-rolling_4_13_9_1` file-conflicts with `linux` but does not package-conflict with it
(otherwise you can't have `linux-rolling_4_13_9_1` and `linux-rolling_4_13_10_1` installed simultaneously),
so separate installation will fail.

`linux-rolling-transitional-4.13.9-1` requires `linux-rolling_4_13_9_1`, so separate installation will fail.
