# Magisk

A magisk module to enable WiFi Adb on boot.

## Usage

Enable this module in magisk.

## Principles

By setting properties to enable wifi adb:

``` shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
