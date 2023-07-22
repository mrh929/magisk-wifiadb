# Magisk-WiFiADB

A Magisk module that enables continuous availability of WiFi ADB service without requiring any Android app.

## Feature

- Ensure WiFi ADB always available

- Disable WiFi ADB in real time
  
  If the module is started on boot, **clicking the button** to open the module and close the module in `Magisk Manager` will directly **modify the status** of the WiFi ADB.

## Usage

Enable this module in magisk.

### Configuration

You can configurure module setting by creating a `config` file in `module root dir` (usually in `/data/adb/modules/magisk-wifiadb`).

And write the following variables:

```
ADB_PORT=[YOUR_ADB_PORT]
ENABLE_LOG=[1 (for enable) / 0 (for disable)]
```

### Logs

If you set `ENABLE_LOG=1`, the logs will be saved in `/data/local/tmp/wifiadb.log`.

## How Does It Work

By setting properties in Android to enable WiFi ADB:

```shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
