# Magisk-WiFiADB

A Magisk module that adds the equivalent of "Wireless(WiFi) Debugging Option" to Stock ROM's running Magisk.

With this module one can have WiFi ADB enabled at all times irresepctive of whether an app is using it(ADB) or not.

A default PORT for wireless debugging is 5555. But with this module you can configure the PORT to one that only YOU know.
This way your Wireless debugging(WiFi ADB) will be secure and private(SAFE)

## Feature

- Ensure WiFi ADB always-ON

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
