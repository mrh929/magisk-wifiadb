# Magisk-WiFiADB

Magisk-WiFiADB is a Magisk module that adds the equivalent of the "Wireless (WiFi) Debugging Option" to Stock ROMs running Magisk.

With this module, you can have WiFi ADB enabled at all times, rather than use an app or turn it on in the Android settings every time before adb debugging.

## Features

- Configure WiFi ADB to activate on boot.
- Toggle WiFi ADB ON/OFF using the Magisk Manager app.
- Set your own private custom port for your device.
- Enable logging to view the WiFi ADB status.

## Usage

**Configuring WiFi ADB to start on boot:**

1. Download the latest release of the module.
2. Manually install it using the Magisk Manager app.
3. Enable the WiFi ADB module in Magisk.
4. Reboot your device.
5. Your wireless debugging is now enabled.

**Commands to establish a wireless ADB connection:**

Connect using the command:
```bash
adb connect your-device-IP:1234
```
Once connected, all other ADB commands will work as expected.

Disconnect using the command:
```bash
adb disconnect
```

**Toggling WiFi ADB ON/OFF:**
Open the Magisk Manager app -> Modules

Use the module switch to enable/disable WiFi ADB.

**Note:** If you accidentally reboot the device while this module switch is turned OFF, WiFi ADB will not start on boot.

## Configuration

You can configure module settings by creating a `config` file in the module root directory (usually located at `/data/adb/modules/magisk-wifiadb`) with the following lines of code:
```
ADB_PORT=1234
ENABLE_LOG=1
```

**Supported configurations:**
The table below shows all the environment variables to configure this module:

| Name                   | Range              | Comment                     |
|------------------------|-------------------|-----------------------------|
| ENABLE_LOG             | 1 for ON / 0 for OFF | ADB log switch              |
| ADB_PORT               | 1~65535           | Your custom ADB port number |
| STATUS_CHK_FREQUENCY   | Any integer above zero | How often the script checks the status of ADB |

**Commands to add the above lines to the config file:**
```bash
adb shell
su
cd /data/adb/modules/magisk-wifiadb/
echo -e "ADB_PORT=1234\nENABLE_LOG=1" > config  # an example 
```

**Note:**
- Grant root permission when prompted on the device.
- 1234 is an example port; replace it with your own secret port number for wireless debugging.

## Logs

If logging is enabled, logs can be viewed at `/data/local/tmp/wifiadb.log`.

## How Does It Work (Under the Hood)

### WiFi ADB

WiFi ADB is enabled by setting properties in Android:
```shell
su
setprop service.adb.tcp.port $adb_port_number
stop adbd
start adbd
```
