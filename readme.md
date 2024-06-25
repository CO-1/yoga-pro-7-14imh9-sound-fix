# Linux realtek sound fix dkms

Easy patch the realtek driver for various laptops until a fix is applied upstream or for development/testing.

## Lenovo Yoga Pro 7 14IMH9 linux sound fix

Yoga Pro 7 14IMH9 uses the same subsystem id as Lenovo Legion 7 16ACHG6 causing wrong fix to be applied.

It needs almost the same fixup as YOGA 9 14IMH9

## Installing

```
make install
```

witch is equivalent to

```
make download && sudo dkms install .
```

Will download the source code from kernel.org and then install patched/updated dkms module.


## Uninstalling

```
sudo make uninstall
```

## Developing / Testing patches for other laptops

Almost every time I switch laptops sound has problems or fixes are not available in my kernel version and I end up creating a dkms module for it.
Since years may pass between switching laptops I may forget how to do it.

In the hope it will help someone (or me) here are the steps for developing a new fix:

1. Edit `PACKAGE_NAME=...` in `dkms.conf` and `Makefile`

2. Comment `PATCH[0]=...` line in `dkms.conf`

3. Run `make download` to download source code for your current kernel or `KERNELRELEASE=x.y.z make download` sources for kernel version x.y.z

4. Modify source files then test if still compiles with `make`

5. Run `dkms install .` to install version being worked on.

6. Reboot and test if it is working.

7. If not working `make uninstall` goto 4

8. Generate patch witch can be upstreamed and place it in patches/.\
Edit `dkms.conf` and place your patch on uncommented `PATCH[0]=...` line.\
Revert changes in sound/ or just remove sound/ and download again.

9. Hopefully share it with others and submit for upstreaming.`