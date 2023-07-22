# Magisk

A Magisk module that enables continuous availability of WiFi ADB service without requiring any Android app.

## Usage

Enable this module in magisk.

## How Does It Work

By setting properties in Android to enable WiFi ADB:

``` shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
