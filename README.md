# These packages are no longer being updated

The packages here are up-to-date with the x86_64 MSYS2 repository as of 2025-11-04, with the exception of the following pacakges which could not be built for i686:
* cargo-c
* fish
* maturin
* msys2-runtime (3.6)
* msys2-runtime-3.4
* msys2-runtime-3.5
* python-cryptography
* python-dulwich
* python-fastbencode
* python-setuptools-rust
* rust

With the addition of rust (which did not have an i686 Cygwin target added to it with the x86_64 target) this list was growing.  Since this coincided with my planned retirement of building
i686 packages with the end of support of Windows 10 in October 2025, I have decided to stop updating this repository.

# Description of this repository

This repository publishes updated i686 msys2 packages, which are no longer built upstream.  These are only relevant for i686 msys2 installs, and chances are you don't really need these. 

If you are *really* sure you need i686 msys2, add the following *before* `[msys]` in your msys32's `/etc/pacman.conf`:

```ini
[build32]
Server = https://github.com/jeremyd2019/msys2-build32/releases/download/repo
SigLevel = Never
```

You can also find 32-bit installers in https://github.com/jeremyd2019/msys2-installer/releases, generally corresponding with the 64-bit installer releases on msys2/msys2-installer.
Note that the 32-bit qt-installer-framework package has been dropped by msys2, so those installers are no longer built.
