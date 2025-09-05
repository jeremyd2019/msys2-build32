This repository publishes updated i686 msys2 packages, which are no longer built upstream.  These are only relevant for i686 msys2 installs, and chances are you don't really need these. 

If you are *really* sure you need i686 msys2, add the following *before* `[msys]` in your msys32's `/etc/pacman.conf`:

```ini
[build32]
Server = https://github.com/jeremyd2019/msys2-build32/releases/download/repo
SigLevel = Never
```

You can also find 32-bit installers in https://github.com/jeremyd2019/msys2-installer/releases, generally corresponding with the 64-bit installer releases on msys2/msys2-installer.
Note that the 32-bit qt-installer-framework package has been dropped by msys2, so those installers are no longer built.
