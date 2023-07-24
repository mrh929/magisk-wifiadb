# Magisk-WiFiADB

A Magisk module that adds the equivalent of "Wireless(WiFi) Debugging Option" to Stock ROM's running Magisk.

With this module one can have WiFi ADB enabled at all times irresepctive of whether an app is using it(ADB) or not.

A default PORT for wireless debugging is 5555. But with this module you can configure the PORT to one that only YOU know.
This way your Wireless debugging(WiFi ADB) will be secure and private(SAFE)

## Feature

- Configure WiFiADB to be activated on boot.
- Toggle WiFiADB - ON/OFF using Magisk Manager App.

## Usage

**Configuring WiFiADB to start on boot :**
Download the latest release of the module.
Install it manually using the Magisk Manager App
Reboot Device.
Enable WiFiADB module in magisk, If its not already enabled after reboot.
Reboot Device

**Toggling WiFiADB ON/OFF :**
Open Magisk Manager App -> Modules
turning the module switch to OFF will disable WiFiADB  (Device reboot not required)
turning the module switch to ON will enable WiFiADB  (Device reboot not required)

Note : If you accidentally happen to reboot device when this module switch is turned OFF then WiFiADB will not be started on boot.

### Configuration

You can configure module setting by creating a `config` file in `module root dir` (usually in `/data/adb/modules/magisk-wifiadb`).

And write the following variables:

```
ADB_PORT=[YOUR_ADB_PORT]
ENABLE_LOG=[1 (for enable) / 0 (for disable)]
```

### Logs

If you set `ENABLE_LOG=1`, the logs will be saved in `/data/local/tmp/wifiadb.log`.


### NOOB STEPS to configure your private port and enabling log

```
adb shell
su
cd /data/adb/modules/magisk-wifiadb/
echo -e "ADB_PORT=1234\nENABLE_LOG=1" >> config
```

**Note :**
grant root permission when prompted on the device.
1234 is the eg port, replace it with your own secret port number as your wireless debugging port.


## How Does It Work

By setting properties in Android to enable WiFi ADB:

```shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
