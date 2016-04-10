#####Setup dependencies

This project uses git submodules.  Before building for the first time, you must run:

```
git submodule init
git submodule update
```

#####CPU load optimization

To optimize emulation performance and to reduce CPU load make sure that the build you install on your device was compiled with *-O3* or *-Os* setting.  
You find this in the project's Xcode buold settings, specifically in the *Apple LLVM - Code Generation*->*Optimization Level* section.

See this link for more information: [Issue39](https://github.com/emufreak/iAmiga/issues/39)
