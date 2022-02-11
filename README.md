# Magisk

A magisk module to enable WiFi ADB on boot.

## Usage

Enable this module in magisk.

## Principles

By setting properties in /common/service.sh to enable WiFi ADB:

``` shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
