#####Project setup

This project uses git submodules.  Before building for the first time, you must run:

```
git submodule init
git submodule update
```

#####ROM
Use iTunes to copy a rom to your device.  The rom file must be called kick.rom or kick13.rom.  Alternatively you can also add the rom file to the Xcode project when building iUAE.

#####Disk drives

df[0]-3 are supported.  Drives can be enabled and disabled when resetting the emulator.  Drives read .adf files - the easiest way to get them onto your device is to use iTunes to copy them.  Alternatively you can also add adf files to the Xcode project when building iUAE, however they will be read-only.  Swipe on a drive row to remove an inserted adf.

#####Hard drives

Hard drive support is currently limited.  Only a single hard drive can be mounted.  Mount and unmount a hard drive file (hdf) when resetting the emulator.  Use xdftool from the excellent [amitools](https://github.com/cnvogelg/amitools) to create an .hdf file, for example:

```
xdftool new.hdf create size=10Mi
```

Use iTunes to copy the .hdf file to your device.  Alternatively you can also add the hdf file to the Xcode project when building iUAE, however it will be read-only.

#####CPU load optimization

To optimize emulation performance and to reduce CPU load make sure that the build you install on your device was compiled with *-O3* or *-Os* setting.  
You find this in the project's Xcode build settings, specifically in the *Apple LLVM - Code Generation*->*Optimization Level* section.

See this link for more information: [Issue39](https://github.com/emufreak/iAmiga/issues/39)
