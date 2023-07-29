# Magisk-WiFiADB

A Magisk module that adds the equivalent of "Wireless(WiFi) Debugging Option" to Stock ROM's running Magisk.

With this module one can have WiFi ADB enabled at all times irresepctive of whether an app is using it(ADB) or not.


## Feature

- Configure WiFiADB to be activated on boot.
- Toggle WiFiADB - ON/OFF using Magisk Manager App.
- Configure your OWN private custom port for your device.
- Enable log to view WiFiADB status.

## Usage

**Configuring WiFiADB to start on boot :**

- Download the latest release of the module.
- Install it manually using the Magisk Manager App.
- Enable WiFiADB module in magisk.
- Reboot Your Device.
- Your Wireless Debugging is enabled.

**Commands to establish wireless ADB connection**

Connect using the command `adb connect your-device-IP:1234`     -      once connected all other adb commands work as they should.

Disconnect using the command `adb disconnect`

**Toggling WiFiADB ON/OFF :**
Open Magisk Manager App -> Modules

use the Module switch to enable / disable WifiADB

Note : If you accidentally happen to reboot device when this module switch is turned OFF then WiFiADB will not be started on boot.

## Configuration

You can configure module settings by creating a `config` file in `module root dir` (usually in `/data/adb/modules/magisk-wifiadb`) with the following lines of code.
```
ADB_PORT=1234 # your custom port no.
ENABLE_LOG=1 # 0 to disable logging.
```

**Commands to add the above lines to the config file.**

```
adb shell
su
cd /data/adb/modules/magisk-wifiadb/
echo -e "ADB_PORT=1234\nENABLE_LOG=1" > config
```


**Note :**
- grant root permission when prompted on the device.
- 1234 is the eg port, replace it with your own secret port number as your wireless debugging port.


## Logs

Logs if 'enabled' can be viewed at `/data/local/tmp/wifiadb.log`.

## How Does It Work (under the hood)

### WiFi adb

By setting properties in Android to enable WiFi ADB:

```shell
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
